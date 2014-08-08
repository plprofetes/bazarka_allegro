module BazarkaAllegro
  class StoreAllegro
    attr_reader :errors

    def initialize
      client = Hooks::Client.new(self)
      @user = Hooks::User.new(client)
      @errors = nil
    end

    # wyslanie aukcji
    def verification_of_data(options = {})
      clear_errors
      begin
        return  @user.do_get_my_data

      rescue Exception => e
        Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
        @errors = e
        false
      end
    end



  end
end