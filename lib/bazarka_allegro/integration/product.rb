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
        #store = self.store
        extension_for_product = self.extension_for_products.where(key: :allegro).first
        #extension = store.extensions.where(key: :allegro).first

        hash = {}

        extension_for_product.details.each do |k,v|
          hash.merge!(k => v)
        end

        return hash

      end
    end
  end
end