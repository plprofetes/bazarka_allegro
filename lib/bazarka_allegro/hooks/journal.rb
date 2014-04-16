module BazarkaAllegro
  module Hooks
    class Journal

      def initialize(client)
        @client = client
      end


      # Pobieranie informacji z dziennika zdarzeń nt. zdarzeń dot. ofert.
      def do_get_site_journal(starting_point = nil, info_type = 0)
          message = {session_handle: @client.session_handle, info_type: info_type }
          message.merge!(starting_point: starting_point) unless starting_point.nil?
          @client.call(:do_get_site_journal, message: message)
      end

      # Pobranie informacji z dziennika zdarzeń nt. zdarzeń dot. formularzy pozakupowych.
      def do_get_site_journal_deals(starting_point = nil)
        message = {session_id: @client.session_handle }
        message.merge!(journal_start: starting_point) unless starting_point.nil?
        @client.call(:do_get_site_journal_deals, message: message)
      end

      # Pobieranie informacji z dziennika zdarzeń o liczbie zmian nt. zdarzeń dot. formularzy pozakupowych.
      def do_get_site_journal_deals_info(starting_point = nil)
        message = {session_id: @client.session_handle }
        message.merge!(journal_start: starting_point) unless starting_point.nil?
        @client.call(:do_get_site_journal_deals_info, message: message)

      end

      # Pobieranie informacji z dziennika zdarzeń o liczbie zmian nt. zdarzeń dot. ofert.
      def do_get_site_journal_info(starting_point = nil, info_type = 0)
        message = {session_handle: @client.session_handle, info_type: info_type }
        message.merge!(starting_point: starting_point) unless starting_point.nil?
        @client.call(:do_get_site_journal_info, message: message)
      end


    end
  end
end
