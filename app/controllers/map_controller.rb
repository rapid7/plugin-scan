class MapController < ApplicationController
  before_filter :authenticate_user!

  def index
    duration
    get_feed
    @map_data = get_map_stats
  end

end
