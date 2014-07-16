module HashableDocument
  def to_hash
    self.fields.keys.inject({}) do |memo, key|
      value = self[key]
      memo[key.to_sym] = value if value.present?
      memo
    end
  end
end
