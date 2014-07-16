class ScanController < ApplicationController
  def index
    @scan_nav = "active"
  end

  def scan
    @client = PluginScan::Client.new(request.headers['HTTP_USER_AGENT'].to_s[0,4096],params,request.remote_ip,request)
    render :partial => 'scan'
  end
end
