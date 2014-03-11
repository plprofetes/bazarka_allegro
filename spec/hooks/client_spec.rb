#encoding: UTF-8
require 'spec_helper'

describe BazarkaAllegro::Hooks::Client do

  before(:all) do
    @client = set_client
  end

  it 'creates client with proper params' do
    @client.user_login.should eq('ebazarka')
    @client.webapi_key.should eq('5c5e4950')
    @client.country_code.should eq(228)
    #@client.local_version.must_equal 1234
  end

  it 'hashes password properly' do
    hash = Digest::SHA256.new.digest('Bazarka123456')
    password = Base64.encode64(hash)

    @client.password.should eq(password)
  end

  it 'have setted endpoint' do
    BazarkaAllegro::Hooks::Client::END_POINT.should eq('https://webapi.allegro.pl/service.php?wsdl')
  end

  describe 'login' do
    it 'logs in' do
        @client.session_handle.should_not be_nil
    end
  end
end