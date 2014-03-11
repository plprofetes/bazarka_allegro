require 'spec_helper'

describe BazarkaAllegro::ProductAllegro do

  before(:all) do
    client = set_client
    client.login
    @allegro = BazarkaAllegro::ProductAllegro.new(client)
  end

  describe "zarzadzanie aukcjami: " do

    it 'dodaje nowa aukcje' do
      options= {}
      item_id = @allegro.add_new_item(options)
      item_id.should_not be_nil
      item_id.should be_instance_of(Integer)
    end

    it 'sciaga konkretna aukcje' do
      #@allegro.
    end

    it 'sciaga wszystkie aukcje' do
      pending
    end

    it 'aktualizacja ilosci sztuk' do
      @allegro.update_item_quantity(32423453, 5)
    end

    it 'kompleksowa zmiana oferty' do
      pending
    end
    end


    it 'zakonczenie aukcji przed czasem' do
      pending
    end

  end

end