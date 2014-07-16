module Stats::Writers
  class IpAddressWriter
    def write(document, visit)
      if visit.has_hit?
        ip = visit.hit[:ip]
        index = find_index_of_ip(document, ip)
        if index
          document.collection.find("_id" => document._id)
                             .update("$inc" => { "ip_addresses.#{index}.count" => 1 })
        else
          add_to_ip_addresses(document, ip)
        end
      end
    end

    private

    def find_index_of_ip(document, ip)
      addresses = document.read_attribute(:ip_addresses)
      if addresses
        addresses.index { |h| h['ip'] == ip }
      end 
    end

    def add_to_ip_addresses(document, ip)
      document.add_to_set(:ip_addresses, { 
        'ip'    => ip, 
        'count' => 1
      })
    end
  end
end
