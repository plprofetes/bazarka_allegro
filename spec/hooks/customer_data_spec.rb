require 'spec_helper'

describe BazarkaAllegro::Hooks::CustomerData do

  before(:all) do
    client = set_client
    client.login
    @allegro = BazarkaAllegro::Hooks::CustomerData.new(client)
  end


  it 'adds package info' do
    response = @allegro.do_add_package_info_to_post_buy_form(transaction_id, package_info: {item: []})
    #puts response
    response.to_hash[:do_get_sell_form_fields_ext_response][:sell_form_fields].should_not be_nil
  end


end