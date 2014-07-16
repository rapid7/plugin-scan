module Stats::Writers
  class ReferrerWriter
    def write(document, visit)
      if visit.has_hit?
        host = visit.hit[:rf]
        index = find_index_of_host(document, host)
        if index
          document.collection.find("_id" => document._id)
                             .update("$inc" => { "referrers.#{index}.count" => 1 })
        else
          add_to_referrers(document, host)
        end
      end
    end

    private

    def find_index_of_host(document, host)
      addresses = document.read_attribute(:referrers)
      if addresses
        addresses.index { |h| h['host'] == host }
      end 
    end

    def add_to_referrers(document, host)
      document.add_to_set(:referrers, { 
        'host'  => host, 
        'count' => 1
      })
    end
  end
end
