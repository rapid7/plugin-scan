class TestController < ApplicationController
  def index

  end

  def api
    @client = PluginScan::Client.new(request.headers['HTTP_USER_AGENT'].to_s[0,4096],params,request.remote_ip,request)
    render :partial => 'api'
  end

  def ajax
    @client = PluginScan::Client.new(request.headers['HTTP_USER_AGENT'].to_s[0,4096],params,request.remote_ip,request)
    render :partial => 'ajax'
  end


  def scan
    @client = PluginScan::Client.new(request.headers['HTTP_USER_AGENT'].to_s[0,4096],params,request.remote_ip,request)
    @website = PluginScan::Websites
    @image = PluginScan::Images
    render :partial => 'scan'
  end


end

