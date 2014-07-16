module Stats::Writers
  class TrafficWriter
    def write(document, visit)
      doc = document.collection.find("_id" => document._id)
      doc.update("$inc" => { "traffic.total" => 1 }) if visit.has_hit?
      doc.update("$inc" => { "traffic.outdated" => 1 }) if visit.has_failures?
    end
  end
end
