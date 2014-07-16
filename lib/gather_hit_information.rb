class GatherHitInformation
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def gather
    info = Info.new
    info[:fid]     = source.feed_id
    info[:ip]      = source.remote_ip
    info[:country] = source.country_name
    info[:ua]      = source.user_agent
    info[:rf]      = source.referrer if source.referrer.present?
    info[:dnt]     = source.dnt if source.dnt.present?
    info[:os_l]    = source.language if source.language.present?
    info[:os]      = source.os_name
    info[:br]      = source.browser_name
    info[:br_v]    = source.browser_version
    source.addons.each { |addon, version| info[addon] = version }
    info
  end
end

class Info
  include Enumerable

  def initialize
    @data = {}
  end

  def []=(key, value)
    @data[key] = value
  end

  def [](key)
    @data[key]
  end

  def each
    @data.each { |d| yield d }
  end

  def to_hash
    @data.to_hash
  end
end
