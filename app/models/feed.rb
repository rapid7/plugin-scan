# encoding: utf-8

class Feed
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  # feed owner 
  field :user_id, type: String

  # Feed ID 
  field :fid, type: String
  index({ fid: 1 }, { :unique => true })

  # Custom Overlay
  field :overlay, type: Integer

  # Custom Header
  field :header, type: String

  # Custom Note
  field :note, type: String

  # Custom Link Text
  field :link_text, type: String

  # Custom URL
  field :url, type: String

  # Custom Redirect
  field :redirect, type: String

  class << self
    def generate_id
      "EM-#{(rand(999999999) + 100000000)}"
    end

    def add_for_user(user, feed_id=generate_id)
      create(:fid     => feed_id, 
             :user_id => user.id)
    end

    def default
      Feed.find_or_create_by(fid: DEFAULT_FEED)
    end
  end

  def redirect_uri
    if redirect.present?
      redirect
    else
      "#{BASE_URL}/scanme"
    end
  end
end

