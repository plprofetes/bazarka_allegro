module BazarkaAllegro
  class CategoryAllegro
    attr_reader :errors
    def initialize(store)
      client = Hooks::Client.new(store)
      @allegro = Hooks::Category.new(client)
      @errors = nil
      @client = client
    end


    # Pobieranie kategorii, jeśli options jest puste to lustuj kategorie najższego poziomu
    # W przeciwnym razie trzeba podać
    def get_categories(options = {})
      clear_errors
      #begin

          @allegro.do_get_cats_data.to_hash[:do_get_cats_data_response][:cats_list][:item]

      #rescue Ebay::RequestError => e
      #  Rails.logger.info "#{e}\n#{e.backtrace.join("\n")}"
      #  @errors = e.errors.map do |error|
      #    error.long_message
      #  end

    end

    def get_category_by_id(category_id)
      @allegro.do_get_category_path(category_id).to_hash[:do_get_category_path_response][:category_path]
    end


    def get_fields_for_category(category_id)
      fields = @allegro.do_get_sell_form_fields_for_category(category_id).body[:do_get_sell_form_fields_for_category_response][:sell_form_fields_for_category][:sell_form_fields_list][:item]
      fields
      #@fields.each do |field|
      #  field.each do |key, value|
      #    if key.to_s == "sell_form_opt" && value.to_i == 1
      #      puts field[:sell_form_title]
      #    end
      #  end
      #end
    end

    def get_required_fields_for_category(category_hash)
      required_fields = {}
      category_hash.each do |key|
        if key[:sell_form_opt].to_i == 1  #wymagane 1, niewymagane 8
          required_fields.merge!(key)
        end
      end
      required_fields
    end

    private
    def clear_errors
      @errors = nil
    end

  end
end