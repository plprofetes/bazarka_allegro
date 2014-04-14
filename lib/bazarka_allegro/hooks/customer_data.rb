module BazarkaAllegro
  module Hooks
    class CustomerData
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def do_get_post_buy_forms_data_for_sellers(transactions_ids = [])
        message = {session_id: @client.session_handle, transactions_ids_array: transactions_ids}
        @client.call(:do_get_post_buy_forms_data_for_sellers, message: message)
      end

    end
  end
end