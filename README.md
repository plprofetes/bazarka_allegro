# Allegro::Webapi

Allegro api wrapper written in ruby. Basic functions supported.

**Support**
- Searching
- Connecting with allegro client via soap (with Savon gem)
- fetching profile data

## Installation

Add this line to your application's Gemfile:

    gem 'allegro-webapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allegro-webapi

## Usage

_Connecting to client_

	 client = Allegro::WebApi::Client.new do |config|
      config.user_login = 'User'
      config.password = 'secret'
      config.webapi_key = '1234'
      config.country_code = 1
    end
 	
    client.login
    
_User data_

	user = Allegro::WebApi::User.new(client)
    user.do_get_my_data

Calls on user: birth_date, phone, first_name, rating, company, city, address, email, id

_Search_

	search = Allegro::WebApi::Search.new(client)
    
    search.search_query(search_string, options)#reference allegro api

_Auction_

    auction = Allegro::WebApi::Auction.new(client)

Metoda pozwala na pobranie listy pól formularza sprzedaży dostępnych we wskazanym kraju. Wybrane pola mogą następnie posłużyć np. do zbudowania i wypełnienia formularza wystawienia nowej oferty z poziomu metody doNewAuctionExt.
    auction.do_get_sell_form_fields
 
    
    
 


