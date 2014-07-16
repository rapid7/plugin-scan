module Stats::Writers
  class OperatingSystemWriter
    def write(document, visit)
      if visit.has_hit?
        index = find_index_of_os(document, visit.hit[:os])
        if index
          document.collection.find("_id" => document._id)
                             .update("$inc" => { "oses.#{index}.count" => 1 })
        else
          document.add_to_set(:oses, {'os' => visit.hit[:os], 'count' => 1})
        end
      end
    end

    private

    def find_index_of_os(document, name)
      oses = document.read_attribute(:oses)
      if oses
        oses.index { |h| h['os'] == name }
      end
    end
  end
end
