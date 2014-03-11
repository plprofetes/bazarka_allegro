require 'spec_helper'

describe BazarkaAllegro::Hooks::Category do

  before(:all) do
    client = set_client
    client.login
    @auction = BazarkaAllegro::Hooks::Category.new(client.login)
  end


  it 'returns category tree for specific category' do
    response = @auction.do_get_category_path(20585)
    #puts response
    response.to_hash[:do_get_category_path_response][:category_path].should_not be_nil
    response.to_hash[:do_get_category_path_response][:category_path][:item][:cat_name].should eq("Filmy")
  end

  it 'returns the whole category tree' do
    response = @auction.do_get_cats_data
    response.to_hash[:do_get_cats_data_response][:cats_list].should_not be_nil
  end

  it 'zwraca wymagane pola do wyslania aukcji dla konkretnej kategorii' do
    response = @auction.do_get_sell_form_fields_for_category(20585)
    #puts response
    response.to_hash[:do_get_sell_form_fields_for_category_response][:sell_form_fields_for_category].should_not be_nil
    response.to_hash[:do_get_sell_form_fields_for_category_response][:sell_form_fields_for_category][:sell_form_fields_list].should_not be_nil
  end


end