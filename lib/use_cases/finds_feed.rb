module UseCases
  class FindsFeed
    def self.find_for_user(user)
      feed = Feed.find_by(user_id: user.id)
      unless feed.present?
        feed = Feed.add_for_user(user)
      end
      feed
    end

    def self.find_by_id(id)
      Feed.find_by(fid: id)
    end
  end
end
