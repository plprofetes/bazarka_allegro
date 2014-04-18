module BazarkaAllegro
  class ProductAllegro
    attr_reader :errors

    def initialize(store)
      client = Hooks::Client.new(store)
      @allegro = Hooks::Auction.new(client)
      @category = Hooks::Category.new(client)
      @errors = nil
    end

    # wyslanie aukcji
    def add_item(options = {})
      clear_errors
      begin
        item =  new_item(options)
        response = @allegro.do_new_auction_ext(item)
        return  response.to_hash[:do_new_auction_ext_response][:item_id]

      rescue Exception => e
        Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
        @errors = e
        Rails.logger.info @errors
        nil
      end
    end


    ## Sprawdzamy czy produkt wyśle się poprawnie
    def verify_add_item(options = {})
      clear_errors
      begin
        item =  new_item(options)
        response = @allegro.do_check_new_auction_ext(item)
        return  response

      rescue Exception => e
        Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
        @errors = e
        Rails.logger.info @errors
        nil
      end
    end


    # produkt został wycofany
    def item_unsold(product)
      product.extension_for_products.where(key: 'allegro').destroy_all
    end

    # produkt został wyprzedany
    def item_sold(product)
      product.extension_for_products.where(key: 'allegro').destroy_all
    end

    def item_auction_checkout_complete(product, transaction_id)
      if product.store.order_lines.where("properties @> ('key => allegro')").where("properties @> ('transaction_id => #{transaction_id}')").present?
        order = product.store.order_lines.where("properties @> ('key => allegro')").where("properties @> ('transaction_id => #{transaction_id}')").first.order
        order.awaiting_fulfillment
      else
        Rails.logger.info "Cos poszlo nie tak nie posiadamy transakcji = #{transaction_id} z produktu = #{product.id}"
      end

    end

    # produkt został sprzedany
    def item_auction_complete
      begin
        response = @allegro.do_get_my_sold_items
        if response.ack == "Failure"
          response.errors.each do |er|
            Rails.logger.info er.long_message
          end
        else

          response.to_hash[:do_get_my_sold_items_response][:sold_items_list].each do  |transaction|

            if product.store.order_lines.where("properties @> ('key => allegro')").where("properties @> ('transaction_id => #{transaction.transaction_id}')").blank?

              billing_first_name = transaction.buyer.buyer_info.shipping_address.name.to_s.split(" ")
              billing_last_name = billing_first_name.pop()
              order  = ::Order.new
              params = {
                  billing_address: "#{transaction.buyer.buyer_info.shipping_address.street1}, #{transaction.buyer.buyer_info.shipping_address.street2}",
                  billing_city: transaction.buyer.buyer_info.shipping_address.city_name,
                  billing_country: transaction.buyer.buyer_info.shipping_address.country,
                  billing_first_name: billing_first_name.join(" "),
                  billing_last_name: billing_last_name,
                  billing_phone: transaction.buyer.buyer_info.shipping_address.phone,
                  billing_region: transaction.buyer.buyer_info.shipping_address.county,
                  billing_zip: transaction.buyer.buyer_info.shipping_address.postal_code,
                  company: transaction.buyer.buyer_info.shipping_address.company_name,
                  customer_id: nil,
                  email: transaction.buyer.email,
                  shipping_address: "#{transaction.buyer.buyer_info.shipping_address.street1}, #{transaction.buyer.buyer_info.shipping_address.street2}",
                  shipping_city: transaction.buyer.buyer_info.shipping_address.city_name,
                  shipping_country: transaction.buyer.buyer_info.shipping_address.country,
                  shipping_first_name: billing_first_name.join(" "),
                  shipping_last_name: billing_last_name,
                  shipping_phone: transaction.buyer.buyer_info.shipping_address.phone,
                  shipping_region: transaction.buyer.buyer_info.shipping_address.county,
                  shipping_zip: transaction.buyer.buyer_info.shipping_address.postal_code,
                  status: 'awaiting_payment',
                  store_id: product.store_id,
                  total: transaction.amount_paid.cents
              }

              order_params = {
                  product_id: product.id,
                  quantity: transaction.quantity_purchased,
                  price: transaction.amount_paid.cents ,
                  product_name: response.item.title,
                  key: 'allegro',
                  transaction_id: transaction.transaction_id,
                  item_id: response.item.item_id,
                  shipment_method_price: transaction.shipping_service_selected.shipping_service_cost.cents,
                  shipment_method_name: transaction.shipping_service_selected.shipping_service
              }
              # metoda do tworzenia ordera
              if order.create_new_order(product.store, params, {}, {}, order_params)
                return true
              else
                Rails.logger.info order.errors
                return false
              end
            end
          end

        end
      rescue Exception => e
        Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
        @errors = e.errors.map do |error|
          error.long_message.gsub('<', '&lt;').gsub('>', '&gt;')
        end
        Rails.logger.info @errors
        nil
      end


    end

    # aktualizacja ilości, jeśli ilość mniejsza od zera ustawiamy produkt niedostępny
    def update_item_quantity(product)
      if product.quantity.to_i > 0
        begin
        response = @allegro.do_change_quantity_item(product.extension_for_products.where(key: 'allegro').first.allegro_id, product.quantity.to_i)
        rescue Exception => e
          Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
        end

      else
        response = @allegro.do_finish_item(product.extension_for_products.where(key: 'allegro').first.allegro_id)
        product.extension_for_products.where(key: 'allegro').first.destroy
      end
      #Rails.logger.info response.inspect
      response
    end



    # aktualizacja statusu na ebayju /zaplacony/wyslany
    def update_state(product, state, order_line)
      hash = {
          item_id: order_line.item_id,
          transaction_id: order_line.transaction_id
      }
      if state == 'paid'
        hash.merge!(paid: true)
      elsif state == 'shipped'
        hash.merge!(shipped: true)
      end

      response = @allegro.complete_sale(hash)
      #Rails.logger.info response.inspect
      response
    end


    private
    def clear_errors
      @errors = nil
    end

    def new_item(options ={})
      new_item_hash = {item: []}
      EXTENSIONS[:allegro]['extension_for_products_details'].each do |i|
        if options[i[0]].present?
          my_item = get_skeleton
          my_item[:fid] = i[0].gsub('attribute_','')
          type = i[1]['allegro_type']

          if type == 'checkbox'
            my_item[:fvalue_int] = options[i[0]].split("|").inject{|sum, x| sum.to_i+x.to_i} unless options[i[0]].blank?
          elsif type == 'string' or type == 'text (textarea)'
            my_item[:fvalue_string] = options[i[0]] unless options[i[0]].blank?
          elsif type == 'integer' or type == "radiobutton" or type == 'combobox'
            my_item[:fvalue_int] = options[i[0]] unless options[i[0]].blank?
          elsif type == 'float'
            my_item[:fvalue_float] = options[i[0]].to_f unless options[i[0]].blank?
          elsif type == 'date'
            my_item[:fvalue_date] = options[i[0]] unless options[i[0]].blank?
          elsif type == 'datetime (Unix time)'
            if options[i[0]].blank?
              my_item[:fvalue_datetime] = DateTime.now.to_i
            else
              my_item[:fvalue_datetime] = DateTime.strptime(options[i[0]], '%d/%m/%Y %H:%M:%S').to_i
            end

          elsif type == 'image (base64Binary)'
            my_item[:fvalue_image] = options[i[0]] unless options[i[0]].blank?
          end
          new_item_hash[:item] << my_item
        end
      end

      new_item_hash
    end

    def get_skeleton
      entry = {
          fid: 0,
          fvalue_string: '',
          fvalue_int: 0 ,
          fvalue_float: 0.0,
          fvalue_image: '',
          fvalue_datetime: 0,
          fvalue_date: '',
          fvalue_range_int: {
              fvalue_range_int_min: 0,
              fvalue_range_int_max: 0
          },
          fvalue_range_float: {
              fvalue_range_float_min: 0,
              fvalue_range_float_max: 0
          },
          fvalue_range_date: {
              fvalue_range_date_min: '',
              fvalue_range_date_max: ''
          }
      }
      entry
    end
  end
end