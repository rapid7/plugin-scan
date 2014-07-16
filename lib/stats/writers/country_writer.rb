module Stats::Writers
  class CountryWriter
    def write(document, visit)
      if visit.has_failures?
        country = visit.hit[:country]
        index = find_index_of_country(document, country)
        if index
          document.collection.find("_id" => document._id)
                             .update("$inc" => { "countries.#{index}.outdated_count" => 1 })
        else
          add_to_countries(document, country)
        end
      end
    end

    private

    def find_index_of_country(document, country)
      countries = document.read_attribute(:countries)
      if countries
        countries.index { |h| h['country'] == country }
      end 
    end

    def add_to_countries(document, country)
      document.add_to_set(:countries, { 
        'country'  => country, 
        'outdated_count' => 1
      })
    end
  end
end
