require 'active_support/all'
require File.expand_path(File.dirname(__FILE__) + "/../../../lib/use_cases/finds_feed")

module UseCases
  describe FindsFeed do
    before { stub_const("Feed", Class.new) } 

    let(:feed) { double(:feed, fid: 'feed-id') }

    describe "::find_for_user" do
      let(:user) { double(:user) }
      before { user.stub(id: '1234') }

      context "when the user has a feed" do
        it "finds the feed from the user id" do
          Feed.stub(:find_by).with(user_id: '1234') { feed }
          expect(FindsFeed.find_for_user(user)).to eq(feed)
        end
      end

      context "when the user does not have a feed" do
        it "creates a new feed with the user id" do
          Feed.stub(:find_by) { nil }
          Feed.should_receive(:add_for_user).with(user) { feed }
          expect(FindsFeed.find_for_user(user)).to eq(feed)
        end
      end
    end

    describe "::find_by_id" do
      context "when the feed exists" do
        it "returns the feed" do
          Feed.stub(:find_by).with(fid: 'feed-id') { feed }
          expect(FindsFeed.find_by_id('feed-id')).to eq(feed)
        end
      end

      context "when the feed does not exist" do
        it "return nil" do
          Feed.stub(:find_by) { nil }
          expect(FindsFeed.find_by_id('bad-id')).to be_nil
        end
      end
    end
  end
end
