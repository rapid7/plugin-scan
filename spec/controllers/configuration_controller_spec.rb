require 'spec_helper'

describe ConfigurationController do
  describe "anonymous user" do
    describe "GET #index" do
      it "requires login" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "user access" do
    let(:user) { create(:user) }
    before :each do
      sign_in user
    end

    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "POST #purge_data" do
      let(:feed) { Feed.create(fid: 'feed_id', user_id: user.id) }
      let(:cleaner) { double(:cleaner).as_null_object }
      before { UseCases::PurgesData.stub(:new => cleaner) }

      it "deletes data by the feed id" do
        cleaner.should_receive(:purge_by_feed).with(feed.fid)
        post :purge_data
      end

      it "redirects to the dashboard" do
        post :purge_data
        expect(response).to redirect_to(:controller => "dashboard", :action => "index")
      end
    end
  end
end
