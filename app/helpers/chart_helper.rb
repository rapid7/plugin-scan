module ChartHelper
  def traffic_chart_for
    yield TrafficChartPresenter.new(@traffic)
  end
end
