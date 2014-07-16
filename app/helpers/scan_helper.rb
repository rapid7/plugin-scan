module ScanHelper
  def scan_status_for
    yield ScanStatusPresenter.new(@client)
  end

  def default_feed_id
    Feed.default.fid
  end
end
