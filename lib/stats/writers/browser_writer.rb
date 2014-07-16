module Stats::Writers
  class BrowserWriter
    def write(document, visit)
      if visit.has_hit?
        index = find_index_of_browser(document, visit.hit[:br])
        if index
          document.collection.find("_id" => document._id)
                             .update("$inc" => { "browsers.#{index}.count" => 1 })
        else
          document.add_to_set(:browsers, {'browser' => visit.hit[:br], 'count' => 1})
        end
      end
    end

    private

    def find_index_of_browser(document, name)
      browsers = document.read_attribute(:browsers)
      if browsers
        browsers.index { |h| h['browser'] == name }
      end
    end
  end
end
