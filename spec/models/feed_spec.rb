require 'spec_helper'

describe Feed do
  describe ".add_for_user" do
    let(:user) { create(:user) }

    before { Feed.stub(:generate_id => 'feed-id') }

    it "adds a new feed" do
      expect { Feed.add_for_user(user) }.to change { Feed.count }
    end

    it "associates the user id with the feed" do
      feed = Feed.add_for_user(user)
      expect(feed.user_id).to eq(user.id.to_s)
    end
  end

  describe "#redirect_uri" do
    it "returns the redirect uri for the feed" do
      feed = Feed.new(redirect: 'http:://example.com')
      expect(feed.redirect_uri).to eq('http:://example.com')
    end

    it "returns a default uri if not assigned" do
      feed = Feed.new
      expect(feed.redirect_uri).to eq("#{BASE_URL}/scanme")
    end
  end

  describe ".default" do
    it "returns the default feed" do
      expect(Feed.default.fid).to eq(DEFAULT_FEED)
    end
  end
end
