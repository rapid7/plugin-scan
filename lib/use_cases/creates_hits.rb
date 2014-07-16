module UseCases
  class CreatesHits
    def self.create(id, data)
      new_hit = Hit.new(data.to_hash)
      new_hit._id = id
      new_hit.save!
    end
  end
end
