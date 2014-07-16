class TrackingController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tracking_nav = "active"
    get_feed
    get_redirect

    if params[:commit] == "Set Redirect"
      set_redirect
      get_redirect
    elsif params[:commit] == "Clear Redirect"
      clear_redirect
      get_redirect
    end
  end

  def set_redirect
    @feed.update_attributes(
      :redirect => params[:redirect]
    )
  end

  def clear_redirect
    @feed.update_attributes(
      :redirect => nil
    )
  end

end
