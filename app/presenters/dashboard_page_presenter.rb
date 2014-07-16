class DashboardPagePresenter
  include Rails.application.routes.url_helpers

  def initialize(args)
    @feed     = args[:feed]
    @duration = Duration.for_days_prior(args[:days])
  end

  def graph_prefix_uri
    dashboard_graph_path(
      @feed.fid,
      @duration.start_time.to_i,
      @duration.end_time.to_i,
      '')
  end
end
