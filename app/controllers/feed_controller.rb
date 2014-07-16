class FeedController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def show

  end

  def new
    feed_id = "EM-" + (rand(999999999) + 100000000).to_s
    Feed.create(
      :fid => feed_id,
      :email => "#{current_user.email}"
    )
  end

  def edit

  end

  def update 

  end

  def destroy

  end

end
