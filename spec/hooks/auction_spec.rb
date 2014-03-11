require 'spec_helper'

describe BazarkaAllegro::Hooks::Auction do

  before(:all) do
    client = set_client
    client.login
    @auction = BazarkaAllegro::Hooks::Auction.new(client)
  end


  it 'gets necessary fields for the form offer' do
    response = @auction.do_get_sell_form_fields_ext
    #puts response
    response.to_hash[:do_get_sell_form_fields_ext_response][:sell_form_fields].should_not be_nil
  end

  it 'lists all present auctions' do
    response = @auction.do_get_my_sell_items
    response.to_hash[:do_get_my_sell_items_response][:sell_items_counter].should_not be_nil
  end

  it 'retrieves all not sold items' do
    item_ids = {item: [3853514543, 3815692642]}
    response = @auction.do_get_my_not_sold_items(item_ids)
    response.to_hash[:do_get_my_not_sold_items_response][:not_sold_items_counter].should_not be_nil
  end

  it 'retrieves all sold items' do
    item_ids = {item: [3853514543, 3815692642]}
    response = @auction.do_get_my_sold_items(item_ids)
    response.to_hash[:do_get_my_sold_items_response][:sold_items_counter].should_not be_nil
  end

  it 'validates and returns validated item description' do
    response = @auction.do_check_item_description('Telefon w świetnym stanie _ nówka, polecam! ')
    response.to_hash[:do_check_item_description_response][:item_description][:description_result].should_not be_nil
  end

  it 'zmienia liczbe sztuk w ofercie' do
    response = @auction.do_change_quantity_item(3863154928, 3)
    response.to_hash[:do_change_quantity_item_response][:item_id].should_not be_nil
  end

  it 'sprawdza czy wystawiana aukcja jest poprawna' do
    response = @auction.do_check_new_auction_ext(NEW_AUCTION)
    response.to_hash[:do_check_new_auction_ext_response][:item_price].should_not be_nil
    response.to_hash[:do_check_new_auction_ext_response][:item_price_desc].should_not be_nil
    response.to_hash[:do_check_new_auction_ext_response][:item_is_allegro_standard].should_not be_nil
  end

  it 'creates a new auction' do
    response = @auction.do_new_auction_ext(NEW_AUCTION)
    response.to_hash[:do_new_auction_ext_response][:item_id].should_not be_nil
    response.to_hash[:do_new_auction_ext_response][:item_info].should_not be_nil
    response.to_hash[:do_new_auction_ext_response][:item_is_allegro_standard].should_not be_nil
  end

  it 'should change the fields in an active auction' do
    #item_id = @auction.do_new_auction_ext(NEW_AUCTION).to_hash[:do_new_auction_ext_response][:item_id]
    response = @auction.do_change_item_fields(3863127302, UPDATED_AUCTION)
    response.to_hash[:do_change_item_fields_response][:changed_item][:item_id].should_not be_nil
    response.to_hash[:do_change_item_fields_response][:changed_item][:item_fields].should_not be_nil
  end

  it 'should end up an auction' do
    response = @auction.do_finish_item(3863154928)
    response.to_hash[:do_finish_item_response][:finish_value].should be 1
  end
end