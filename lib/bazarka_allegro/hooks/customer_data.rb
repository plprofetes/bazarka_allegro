module BazarkaAllegro
  module Hooks
    class CustomerData
      attr_reader :client

      def initialize(client)
        @client = client
      end

      # Pobieranie danych z wypełnionych formularzy pozakupowych oraz dopłat (dla sprzedających).
      def do_get_post_buy_forms_data_for_sellers(transactions_ids = [])
        message = {session_id: @client.session_handle, transactions_ids_array: { item: transactions_ids} }
        @client.call(:do_get_post_buy_forms_data_for_sellers, message: message)
      end

      # Pobieranie danych kontaktowych kupujących.
      def do_my_contact(auction_id_list = [], offset = 0)
        message = {session_handle: @client.session_handle, auction_id_list: { item: auction_id_list}, offset: offset }
        @client.call(:do_my_contact, message: message)
      end

    end
  end
end