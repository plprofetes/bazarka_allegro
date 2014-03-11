module BazarkaAllegro
  module Hooks
    class CustomerData
      attr_reader :client

      def initialize(client)
        @client = client
      end


    end
  end
end