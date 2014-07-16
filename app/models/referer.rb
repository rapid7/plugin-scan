# encoding: utf-8
class Referer
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  # Feed index
  field :fid, type: String
  index({ fid: 1 })

  # Authorized referers domains
  field :rf, type: String

end
