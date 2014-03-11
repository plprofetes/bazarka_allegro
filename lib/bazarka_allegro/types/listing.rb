module BazarkaAllegro
  module Types
    class Listing
      LISTING_TYPES = {
        0 => "3",
        1 => "5",
        2 => "7",
        3 => "10",
        4 => "14",
        5 => "30"
      }

      ADDITIONAL_OPTIONS = {
        1 => "Pogrubienie",
        2 => "Miniaturka",
        4 => "Podświetlenie",
        8 => "Wyroznienie",
        16 => "Strona kategorii",
        32 => "Strona glowna allegro",
        64 => "Znak wodny"
      }

      SHIPMENT_COSTS_COVERAGE = {
          0 => "Seller",
          1 => "Buyer"
      }

      UNIT_OF_MEASURES = {
          0 => "Sztuk",
          1 => "Kompletow",
          2 => "Par"
      }
    end
  end
end