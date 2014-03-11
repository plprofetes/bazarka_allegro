require 'spec_helper'

describe BazarkaAllegro::CategoryAllegro do

  before(:all) do
    client = set_client
    client.login
    @category_allegro = BazarkaAllegro::CategoryAllegro.new(client)
  end


  it 'pobierz drzewo dla konkretnej kategorii' do
    response = @category_allegro.get_categories({category_id: 20585})
    #puts response
  end

  it 'pobierz drzewo dla wszystkich kategorii' do
    response = @category_allegro.get_categories
    #puts response
  end

  it 'pobierz pola dla kategorii' do
    fields = @category_allegro.get_fields_for_category(20585)
    fields.should_not be_nil
    fields.count.should be > 5
  end

  it 'podaj tylko wymagane pola' do
    fields = @category_allegro.get_fields_for_category(20585)
    required_fields = @category_allegro.get_required_fields_for_category(fields)
    required_fields.should_not be_nil
    required_fields.count.should be > 5
  end

  it 'stworz plik yamlowy z polami do wypelnienia' do
    fields = @category_allegro.get_fields_for_category(20585)
    puts fields
    File.open("j.yml", 'w+', external_encoding: 'utf-8') do |f|
      f.write(fields.to_yaml)
    end
  end

end