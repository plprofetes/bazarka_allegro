module BazarkaAllegro
  module Integration
    module Product
      def self.included(base)
        base.after_update  :update_allegro, if: :is_connect_with_allegro?
        #base.before_update  :update_ebay
        #base.after_save  :update_from_ebay
        #base.before_save  :update_from_ebay
        #base.after_validation  :send_to_ebay
        #base.before_validation  :send_to_ebay
      end

      def update_allegro
        Rails.logger.info "-----------------"
        Rails.logger.info "Update Allegro"
        Rails.logger.info "-----------------"
        product = ProductEbay.new(self.store)
        product.update_item_quantity(self)

      end

      def extension_update_state_allegro(state, order_line)
        product = ProductEbay.new(self.store)
        product.update_state(self, state, order_line)
      end

      def update_from_allegro(event_type, transaction_id=nil)
        product = ProductEbay.new(self.store)
        if event_type == "ItemSold"
          product.item_sold(self)
        elsif  event_type == "ItemUnsold"
          product.item_unsold(self)
        elsif  event_type == "ItemWon"
          product.item_sold(self)
        elsif  event_type == "EndOfAuction"
          product.item_unsold(self)
        # klient zaplacil i idzie potwierdzenie
        elsif  event_type == "AuctionCheckoutComplete"
          product.item_auction_checkout_complete(self, transaction_id)
        # klient kupil ale jeszcze nie zaplail
        elsif  event_type == "FixedPriceTransaction"
          product.item_auction_complete(self, transaction_id)

        end
      end

      def send_to_allegro
        product = ProductAllegro.new(self.store)
        product.add_item(options)
        product
      end

      def verify_in_allegro
        product = ProductAllegro.new(self.store)
        product.verify_add_item(options)
        product
      end

      def delete_from_ebay

      end


      private
      def is_connect_with_allegro?
        self.store.ebay  and self.extension_for_products.where(key: :allegro).present?
      end

      def options
        store = self.store
        extension_for_product = self.extension_for_products.where(key: :allegro).first
        extension = store.extensions.where(key: :allegro).first

        #shipping = []
        #EXTENSIONS[:allegro]['extension_for_products_details']['shipping']['length'].to_i.times do |i|
        #  if  extension_for_product.send("shipping_service_#{i}").present? and extension_for_product.send("shipping_service_cost_#{i}").present?
        #    shipping << {shipping_service: extension_for_product.send("shipping_service_#{i}"), shipping_service_cost: extension_for_product.send("shipping_service_cost_#{i}"), shipping_service_code: extension_for_product.send("shipping_service_code_#{i}"), shipping_region_code: extension_for_product.send("shipping_region_code_#{i}")}
        #  end
        #end

        hash = {
          auction_title: self.name,
          description: self.description,
          category_id: extension_for_product.category_id.to_i,
          starting_date: extension_for_product.starting_date,
          listing_time: extension_for_product.listing_time,
          #quantity: self.quantity,
          quantity: extension_for_product.quantity,
          #starting_price: self.price.cents+Money.parse(extension_for_product.manipulation_cost).cents,
          #starting_price: self.price.cents,
          #minimal_price: extension_for_product.minimal_price,
          buy_now_price: extension_for_product.buy_now_price,
          bold_title:  extension_for_product.bold_title,
          thumbnail:  extension_for_product.thumbnail,
          highlight:  extension_for_product.highlight,
          featured:  extension_for_product.featured,
          category_page:  extension_for_product.category_page,
          main_page:  extension_for_product.main_page,
          watermark:  extension_for_product.watermark,
          shipment_costs_coverage: extension_for_product.shipment_costs_coverage,
          shipment_abroad: extension_for_product.shipment_abroad,
          invoice_issue: extension_for_product.invoice_issue,
          advance_payment: extension_for_product.advance_payment,
          bank_account_1: extension_for_product.bank_account_1,
          bank_account_2: extension_for_product.bank_account_2,
          unit_of_measure: extension_for_product.unit_of_measure,
          #postal_code: store.postal_code,
          postal_code: extension_for_product.postal_code,
          city: extension_for_product.city,
          county: extension_for_product.county,
          country: extension_for_product.country,

          free_pick_up: extension_for_product.free_pick_up,
          send_via_email: extension_for_product.send_via_email,
          free_pick_up_after_payment: extension_for_product.free_pick_up_after_payment
          #currency: store.currency,
          #abbreviation: store.country,
          #dispatch_time_max: extension_for_product.dispatch_time_max,
          ##picture_details
          #listing_duration: extension_for_product.listing_duration,
          #listing_type: extension_for_product.listing_type,
          #payment_methods: extension_for_product.payment_methods,
          #quantity: self.quantity,
          #refund: extension_for_product.refund,
          #returns_accepted_option: extension_for_product.returns_accepted_option,
          #return_policy_description:  extension_for_product.return_policy_description,
          #returns_within: extension_for_product.returns_within,
          #shipping_type: extension_for_product.shipping_type,
          #shipping: shipping,
          #paypal_email_address: extension.paypal_email_address,
          #picture_urls: self.image_products.map{|x| x.url(:medium)},
          #condition_id: extension_for_product.condition_id.to_i,


        }

      end
    end
  end
end