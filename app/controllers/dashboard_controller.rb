class DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout false, :except => ['index']

  def index
    @dashboard_nav = "active"
    # once we can assign a new duration to @duration,
    # push the presenter creation to the view
    @presenter = DashboardPagePresenter.new(
      :feed => UseCases::FindsFeed.find_for_user(current_user),
      :days => 30
    )
  end

  def graph
    get_software
    @feed = UseCases::FindsFeed.find_by_id(params[:fid])
    duration

    @chart_dimensions = "width:400, height:400"

    @graph_id = sprintf("N%.8x%.8x", rand(0x100000000), rand(0x100000000))

    case params[:graph]
    when 'statistics-traffic-tab'
      @traffic = UseCases::FindsTraffic.find_for(@feed, time_period)
      render :partial => 'dashboard/charts/traffic_total' 

    when 'statistics-os-tab'
      @chart_dimensions = "width:800, height:200"
      @os = os_stats
      render :partial => 'dashboard/charts/os_total'

    when 'statistics-browser-tab'
      @chart_dimensions = "width:800, height:200"
      @browsers = browser_stats
      render :partial => 'dashboard/charts/browser_total'

    when /statistics\-(dvr|flash|java|qt|reader|rp|shock|silver|vlc|wmp)\-tab/
      @chart_dimensions = "width:800, height:200"
      @addon_id = $1.strip

      @addon_name = @software_names[@addon_id]
      @hits_daily_data = hits_daily("ao_#{@addon_id}")
      @addon_data = get_normal_stats(@addon_id)
      @addon_exploitable = get_exploitable_stats(@addon_id)

      render :partial => 'dashboard/charts/addon_total'

    when 'exploitable-all-tab'
      # XXX: This requires pagination to scale properly
      get_exploitable
      render :partial => 'dashboard/exploitable_all_tab'

    when /exploitable\-(dvr|flash|java|qt|reader|rp|shock|silver|vlc|wmp)\-tab/
      @addon_id   = $1.strip
      @addon_name = @software_names[ @addon_id ]

      # XXX: This requires pagination to scale properly
      # XXX: refactor to just entries containing the addon
      get_exploitable
      render :partial => 'dashboard/exploitable_addon_tab'

    when 'sources-all-tab'
      # XXX: This requires pagination to scale properly
      get_ips
      render :partial => 'dashboard/sources_all_tab'

    when 'websites-all-tab'
      # XXX: This requires pagination to scale properly
      get_referers
      render :partial => 'dashboard/websites_all_tab'

    when 'map-world-tab'
      @map_data = get_map_stats
      render :partial => 'dashboard/map_world'

    else
      render :text => ''
    end
  end

  private

  def get_software
    @software_names = SoftwareNames.new.to_hash
  end

  def hits_daily(addon_id=nil)
    finder = UseCases::FindsTrafficResults.new
    traffic_results = if addon_id
                        finder.find_by_addon(feed_id, addon_id, time_period)
                      else
                        finder.find_all(feed_id, time_period)
                      end 

    @traffic_dates = to_safe_csv(traffic_results.days)
    @traffic_hits_data = to_safe_csv(traffic_results.hits_per_day)
    @traffic_exploitable_data = to_safe_csv(traffic_results.exploitable_per_day)
    to_safe_csv(traffic_results.totals_per_day)
  end

  def browser_stats
    finder = UseCases::FindsBrowserStats.new 
    records = finder.find_stats(feed_id, time_period)
    stats = SoftwareStats.new(records) 

    @browser_chart_names = to_safe_csv(stats.names)
    @browser_chart_count = to_safe_csv(stats.counts)
    to_safe_csv(stats.count_per_name)
  end

  def os_stats
    finder = UseCases::FindsOperatingSystemStats.new
    records = finder.find_stats(feed_id, time_period)
    stats = SoftwareStats.new(records)

    @os_chart_names = to_safe_csv(stats.names)
    @os_chart_count = to_safe_csv(stats.counts)
    to_safe_csv(stats.count_per_name)
  end

  def get_map_stats
    finder = UseCases::FindsMapStats.new
    stats = finder.find_stats(feed_id, time_period)
    to_safe_csv(stats.count_per_country)
  end

  def get_exploitable
    finder = UseCases::FindsExploitableHosts.new
    @exploitable_hosts = finder.find_recent_exploits(feed_id, time_period)
  end

  def get_referers
    finder = UseCases::FindsReferrerStats.new
    stats = finder.find_stats(feed_id, time_period)
    @referers = stats.ordered_referrers
  end

  def get_ips
    finder = UseCases::FindsIPStats.new
    stats = finder.find_stats(feed_id, time_period) 
    @ips = stats.ordered_ips
  end

  def get_exploitable_stats(software)
    finder = UseCases::FindsExposureStats.new
    stats = finder.find_exposures(feed_id, time_period, software)
    to_safe_csv(stats.count_per_stat)
  end

  def get_normal_stats(software)
    finder = UseCases::FindsSoftwareVersions.new
    stats = finder.find_versions(feed_id, time_period, software)
    to_safe_csv(stats.count_per_version)
  end

  def feed_id
    @feed[:fid]
  end

  def time_period
    Duration.between(@duration_ts, @duration_te)
  end

  def to_safe_csv(values)
    values.join(', ').html_safe
  end
end
