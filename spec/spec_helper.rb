require_relative '../lib/bazarka_allegro'
#require 'test_xml/spec'
#require 'minitest'
#require 'minitest/spec'
#require 'minitest/autorun'
#require 'webmock/minitest'
#require 'vcr'


#VCR.configure do |c|
#  c.cassette_library_dir = 'spec/fixtures/dish_cassettes'
#  c.hook_into :webmock
#end

RSpec.configure do |config|
  #config.include Capybara::DSL
  config.color_enabled = true

end


def set_client
  BazarkaAllegro::Hooks::Client.new(nil) do |config|
    #config.user_login = ENV['USER_LOGIN']
    #config.password = ENV['PASSWORD']
    #config.webapi_key = ENV['API_KEY']
    #config.country_code = ENV['COUNTRY_CODE']
    #config.local_version = ENV['LOCAL_VERSION']
    config.user_login = 'ebazarka'
    config.password = 'Bazarka123456'
    config.webapi_key = '5c5e4950'
    config.country_code = 1
  end
end

NEW_AUCTION = {  item: [
    {
        fid: 1,
        fvalue_string: 'dupa',
        fvalue_int: 0 ,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 2,
        fvalue_string: '',
        fvalue_int: 1885 ,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 4,
        fvalue_string: '',
        fvalue_int: 0 ,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 5,
        fvalue_string: '',
        fvalue_int: 1,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 6,
        fvalue_string: '',
        fvalue_int: 0,
        fvalue_float: 1.99,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 9,
        fvalue_string: '',
        fvalue_int: 228,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 10,
        fvalue_string: '',
        fvalue_int: 213,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 11,
        fvalue_string: 'Torun',
        fvalue_int: 0,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 14,
        fvalue_string: '',
        fvalue_int: 1,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 24,
        fvalue_string: 'Opis',
        fvalue_int: 0,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 32,
        fvalue_string: '87-100',
        fvalue_int: 0,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 35,
        fvalue_string: '',
        fvalue_int: 2,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 49,
        fvalue_string: '',
        fvalue_int: 0,
        fvalue_float: 9.99,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    }

]}

UPDATED_AUCTION = {  item: [
    {
        fid: 1,
        fvalue_string: 'zaupdatowana auckja',
        fvalue_int: 0 ,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 2,
        fvalue_string: '',
        fvalue_int: 1885 ,
        fvalue_float: 0,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    },
    {
        fid: 49,
        fvalue_string: '',
        fvalue_int: 0,
        fvalue_float: 19.99,
        #fvalue_image: 0,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {
            fvalue_range_int_min: 0,
            fvalue_range_int_max: 0
        },
        fvalue_range_float: {
            fvalue_range_float_min: 0,
            fvalue_range_float_max: 0
        },
        fvalue_range_date: {
            fvalue_range_date_min: '',
            fvalue_range_date_max: ''
        }
    }

]}


