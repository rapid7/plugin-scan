class VersionController < ApplicationController
  before_filter :authenticate_user!

  def index
    @version_nav = "active"
    get_feed

  end
end
