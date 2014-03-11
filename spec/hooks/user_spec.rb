require 'spec_helper'


describe BazarkaAllegro::Hooks::User do

  before(:all) do
    client = set_client
    client.login
    @user = BazarkaAllegro::Hooks::User.new(client.login)
    @user.do_get_my_data
    @user
  end

  it 'gets my user data' do
      @user.do_get_my_data.should_not be_nil
  end

  describe 'more specific info' do

    it 'gets user first name and last name' do
      @user.first_name.should_not be_nil
      @user.last_name.should_not be_nil
    end

    it 'gets email' do
      @user.email.should_not be_nil
    end

    it 'gets city' do
      @user.city.should_not be_nil
    end

    it 'gets phone' do
      @user.phone.should_not be_nil
    end

    it 'gets rating' do
      @user.rating.should_not be_nil
    end

    it 'gets id' do
      @user.id.should_not be_nil
    end

    it 'gets birth_date' do
      @user.birth_date.should_not be_nil
    end

    it 'gets address' do
      @user.address.should_not be_nil
    end

    #it 'gets company' do
    #  @user.company.should be_falsey
    #end
  end
end