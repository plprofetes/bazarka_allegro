module BazarkaAllegro
  module Hooks
    class Discount

      def initialize(client)
        @client = client
      end


      # Jeśli jeszcze nie został uzupełniony formularz po aukcyjny czyli nie została uzupełniona
      def do_get_deals(item_id, buyer_id)
        message = {session_handle: @client.session_handle, item_id: item_id, buyer_id: buyer_id }
        @client.call(:do_get_deals, message: message)
      end
    end
  end
end
