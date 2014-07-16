class ApplicationController < ActionController::Base
  before_filter :prevent_clickjacking
	protect_from_forgery
	helper :all

  require 'uri'

private

  def prevent_clickjacking
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
  end

  def lookup_feed(fid)
    unless fid.to_s =~ /^EM\-\d+$/
      return
    end
    @feed = UseCases::FindsFeed.find_by_id(fid)
  end

  def get_redirect
    @redirect = @feed.redirect_uri
  end

  def set_tick_interval
    case @duration[1]
      when 30
        '3'
      else
        '1'
    end
  end

  def duration
    if params[:duration]
      ["Month", 30]
    else
      if params[:duration_ts] and params[:duration_te]
        @duration_ts = Time.at(params[:duration_ts].to_i)
        @duration_te = Time.at(params[:duration_te].to_i)
        @duration    = [ "Custom", ((@duration_te - @duration_ts) / (24 * 3600)).to_i ]
        @tick_interval = set_tick_interval
      else
        @duration = ["Month", 30]
        @tick_interval = set_tick_interval
        @duration_month = "active"
      end
    end
    @duration_ts = (Time.now.utc - @duration[1].days).beginning_of_day
    @duration_te = (Time.now.utc).end_of_day
  end

  def get_feed
    @feed = UseCases::FindsFeed.find_for_user(current_user)
  end
end
