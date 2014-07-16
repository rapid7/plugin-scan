class InspectParameterSource
  attr_reader :source

  def initialize(source)
    @source = source
  end

  # this is for temporary scaffolding
  def params
    @source.params
  end

  # this is for temporary scaffolding
  def request
    @source.request
  end

  def feed_id
    source.params[:fid]
  end

  def tid
    # Pull the TID from the cookie
    tid = source.cookie_value_for(:tid)

    # Fall back to the URL parameter but prefer the cookie
    if (tid.blank? || tid.length != 24)
      tid = source.params[:tid]
    end

    if (tid.blank? || tid.length != 24)
      nil
    else
      tid
    end
  end

  def remote_ip
    source.request.remote_ip
  end

  def country_name
    begin
      $geoip_db ||= GeoIP.new("#{Rails.root}/vendor/data/GeoLiteCity.dat")
      $geoip_db.country(remote_ip).country_name
    rescue
      return "None"
    end
  end

  def referrer
    ref = source.request.headers['HTTP_REFERER']
    ref = ref.to_s.strip
    return unless ref.length > 0
    host = URI.parse(ref).host rescue nil
    return unless host
    host.sub(/^www\./, '')
  end

  def user_agent
    source.request.headers['HTTP_USER_AGENT'].to_s[0,4096]
  end

  def dnt
    source.request.headers['DNT'][0,16] if source.request.headers['DNT']
  end

  def language
    parts = source.request.headers['HTTP_ACCEPT_LANGUAGE'].to_s.split(';')
    if parts.any?
      parts.first[0,1024]
    end
  end

  def addons
    %W{ dvr flash java qt reader silver rp shock wmp vlc }.inject({}) do |memo, addon|
      if source.params[addon]
        memo["ao_#{addon}".intern] = source.params[addon].to_s[0,1024]
      end
      memo
    end
  end

  def os_name
    case user_agent
      when /ubuntu/i
        "ubuntu"
      when /linux/i
        "linux"
      when /macintosh/i
        "macintosh"
      when /windows/i
        "windows"
      else
        "Unknown"
    end
  end

  def browser_name
    case user_agent
      when /chromium/i
        browser = "chromium"
      when /chrome/i
        browser = "chrome"
      when /safari/i
        browser = "safari"
      when /firefox/i
        browser = "firefox"
      when /msie/i
        browser = "ie"
      else
        browser = "Unknown"
    end
  end

  def browser_version
    case user_agent
      when /chromium/i
        browser_version = user_agent.split()[-3].split("\/")[1]
      when /chrome/i
        browser_version = user_agent.split()[-2].split("\/")[1]
      when /safari/i
        browser_version = user_agent.split()[-1].split("\/")[1]
      when /firefox/i
        browser_version = user_agent.split()[-1].split("\/")[1]
      when /msie/i
        browser_version = user_agent.split("\;")[1].split()[1]
      else
        browser_version = "0"
    end
  end
end

