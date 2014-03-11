module BazarkaAllegro
  module Hooks
    class Category

      def initialize(client)
        @client = client
      end

      # pobiera info dla konkretnej kategorii
      def do_get_category_path(category_id)
        message = {session_id: @client.session_handle, category_id: category_id}
        @client.call(:do_get_category_path, message: message)
      end

      # pobiera drzewo wszystkich categorii
      def do_get_cats_data
        message = {country_id: @client.country_code, webapi_key: @client.webapi_key}
        @client.call(:do_get_cats_data, message: message)
      end

      # sciagnij pola wymagane dla konkretnej kategorii
      #Tablica struktur zawierająca szczegółowe informacje o polach formularza sprzedaży dla kategorii.
      #sell-form-id | int
      #    Identyfikator pola.
      #sell-form-title | string
      #    Nazwa pola.
      #sell-form-cat | int
      #    Identyfikator kategorii, do której odnosi się pole (dotyczy też wszystkich podkategorii wskazanej kategorii). 0 oznacza, że parametr odnosi się do wszystkich kategorii.
      #sell-form-type | int
      #    Określenie typu pola w formularzu sprzedaży (1 - string, 2 - integer, 3 - float, 4 - combobox, 5 - radiobutton, 6 - checkbox, 7 - image (base64Binary), 8 - text (textarea), 9 - datetime (Unix time), 13 - date).
      #sell-form-res-type | int
      #     Wskazanie na typ pola, w którym należy przekazać wybraną wartość pola (1 - string, 2 - integer, 3 - float, 7 - image (base64Binary), 9 - datetime (Unix time), 13 - date).
      #sell-form-def-value | int
      #    Domyślna wartość pola (dla pól typu combobox/radiobutton/checkbox - na podstawie sell-form-opts-values).
      #sell-form-opt | int
      #    Informacja na temat obligatoryjności pola (1 - pole obowiązkowe, 8 - pole opcjonalne).
      #sell-form-pos | int
      #    Pozycja pola na liście pól w formularzu sprzedaży. 0 oznacza, że stosowane jest sortowanie alfabetyczne.
      #sell-form-length | int
      #    Dopuszczalny rozmiar (w znakach) przekazywanej wartości pola.
      #sell-min-value | string
      #    Minimalna możliwa do przekazania wartość pola (dot. pól typu: int, float, combobox, checkbox, date; wartość 0 wskazuje na brak dolnego ograniczenia).
      #sell-max-value | string
      #    Maksymalna możliwa do przekazania wartość pola (dot. pól typu: int, float, combobox, checkbox, date; wartość 0 wskazuje na brak górnego ograniczenia).
      #sell-form-desc | string
      #    Opis kolejnych wartości, które można ustawić dla pola (dot. pól typu combobox/radiobutton/checkbox).
      #sell-form-opts-values | string
      #    Wskazanie konkretnych wartości (odpowiednich dla opisów wyżej), które można ustawić dla danego pola (dot. pól typu combobox/radiobutton/checkbox, dla pól typu checkbox kolejne wartości można sumować).
      #sell-form-field-desc | string
      #    Szczegółowy opis pola.
      #sell-form-param-id | int
      #    Unikalny identyfikator pola.
      #sell-form-param-values | string
      #    Unikalne i niezmienne identyfikatory wartości parametru (dot. pól typu combobox/radiobutton/checkbox).
      #sell-form-parent-id |int
      #    Identyfikator parametru rodzica (jego sell-form-param-id - tylko dla parametrów zależnych nie będących na szczycie hierarchi. Jeżeli dany parametr nie jest parametrem zależnym, lub jeżeli znajduje się na szczycie hierarchi parametrów zależnych - w polu zwracana zostanie wartość 0).
      #sell-form-parent-value | string
      #    Wartość parametru rodzica, dla której parametr powiązany może być wykorzystany (tylko dla parametrów zależnych. Jeżeli dany parametr nie jest parametrem zależnym - w polu nie zostanie zwrócona żadna wartość).
      #sell-form-unit | string
      #    Jednostka parametru (jeżeli została określona).
      #sell-form-options | int
      #    Maska bitowa informująca o własnościach parametru (1 - parametr zależny, 2 - parametr typu checkbox z wykorzystaniem operatora OR, z możliwym wyborem jednej, wielu lub wszystkich wartości przez sprzedającego w formularzu sprzedaży, 4 - parametr typu checkbox z wykorzystaniem operatora OR, z możliwym wyborem tylko jednej wartości przez sprzedającego w formularzu sprzedaży, 8 - parametr zakresowy; w przypadku gdy wartości 2 oraz 4 nie są ustawione, działanie parametru typu checkbox opiera się na operatorze AND).
      #
      def do_get_sell_form_fields_for_category(category_id)
        message = {webapi_key: @client.webapi_key, country_id: @client.country_code, category_id: category_id }
        @client.call(:do_get_sell_form_fields_for_category, message: message )
      end

    end
  end
end