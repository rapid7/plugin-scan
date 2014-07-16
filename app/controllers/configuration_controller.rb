class ConfigurationController < DashboardController
  protect_from_forgery
  before_filter :authenticate_user!

  def index
    render :index
  end

  def purge_data
    get_feed
    cleanse
    redirect_to :controller => 'dashboard', :action => 'index'
  end

  private 

  def cleanse
    cleaner.purge_by_feed(@feed[:fid])
  end

  def cleaner
    UseCases::PurgesData.new
  end
end
