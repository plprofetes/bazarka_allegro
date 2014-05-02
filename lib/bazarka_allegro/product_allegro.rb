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
      extension_for_product = product.extension_for_products.where(key: 'allegro').first
      if extension_for_product.allegro_quantity.to_i > 0
        begin
          # pobieramy id aukcji allegro, pobieramy dane aukcji, ile jest produktów i ile było na początku
          # bierzemy tylko dane nam potrzebne z aukci czyli quantity
          # sprawdzamy czy liczba produktów w sklepie + liczba produktów sprzedanych na allegro równa sie liczbie
          # produktów wystawionych na allegro, jeśli nie to aktualizujemy liczbę wystawionych na allegro która
          # równa się liczba w systemie + liczba sprzedanych

          allegro_id = extension_for_product.allegro_id
          allegro_product = @allegro.do_get_items_info([allegro_id]).to_hash
          allegro_product_info = allegro_product[:do_get_items_info_response][ :array_item_list_info][:item][:item_info]
          quantity = extension_for_product.allegro_quantity.to_i + (allegro_product_info[:it_starting_quantity].to_i - allegro_product_info[:it_quantity].to_i)
          if quantity < allegro_product_info[:it_starting_quantity].to_i
            response = @allegro.do_change_quantity_item(allegro_id, quantity)
          end
        rescue Savon::SOAPFault => e
          Rails.logger.info "#{e}"
          if e.message =~ /ERR_YOU_CANT_CHANGE_ITEM/i
            product.extension_for_products.where(key: 'allegro').first.destroy
          else
            raise "#{e}"
          end
        rescue Exception => e
          Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
          raise "#{e}"
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
      options.each do |option, value|
        if option =~ /^attribute_(\d+)$/
          my_item = get_skeleton
          my_item[:fid] = option.gsub('attribute_','')
          type = options[option.gsub('attribute_', 'attributetype_')]

          if type == 'checkbox' # 6
            my_item[:fvalue_int] = value.split("|").inject{|sum, x| sum.to_i+x.to_i} unless value.blank?
          elsif type == 'string' or type == 'text (textarea)'    # 1, 8
            my_item[:fvalue_string] = value unless value.blank?
          elsif type == 'integer' or type == "radiobutton" or type == 'combobox' # 2, 5, 6
            my_item[:fvalue_int] = value unless value.blank?
          elsif type == 'float' # 3
            my_item[:fvalue_float] = value.to_f unless value.blank?
          elsif type == 'date' # 13
            my_item[:fvalue_date] = value unless value.blank?
          elsif type == 'datetime (Unix time)' # 9
            if value.blank?
              my_item[:fvalue_datetime] = DateTime.now.to_i
            else
              my_item[:fvalue_datetime] = DateTime.strptime(value, '%d/%m/%Y %H:%M:%S').to_i
            end
          elsif type == 'image (base64Binary)' # 7
            my_item[:fvalue_image] = value unless value.blank?
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