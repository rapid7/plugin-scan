class CollectController < ApplicationController
  skip_before_filter :prevent_clickjacking

  def index
    unless params[:fid] =~ /^EM\-\d+$/ and params[:w_type] =~ /^\d+$/
      return
    end

    @opts = params[:opts] || "0"

    @tid = cookies[:tid]
    if not (@tid and @tid.length == 24)
      @tid = sprintf("%.8x%.8x%.8x", rand(0x100000000), rand(0x100000000), rand(0x100000000))
    end

    cookies[:tid] = { :value => @tid, :expires => 1.hour.from_now }

    unless Feed.where(:fid=>"#{params[:fid]}").empty?
      if params[:lab].to_s.to_i == 1
        @lab_mode = '1'
      else
        @lab_mode = '0'
      end

      # Cache for one hour, works with the TestID (TID) to prevent duplicates
      # when the Cookie method fails
      expires_in 1.hour, :public => false
      headers['ETag'] = @tid
      make_javascript_code
      respond_to do |format|
        format.js
      end
    end
  end

  def make_javascript_code

    tid = @tid
    pre = "bscan_#{tid}_"

    collect_code = %Q^

var PluginScanHostDetails = {};

function #{pre}RunAgent(){
    var params = #{pre}CollectParams();
    var sobj   = document.createElement("script");
    var surl   = "#{BASE_URL}/#{params[:fid]}/#{params[:w_type]}/#{@lab_mode}/#{@opts}/inspect.js?" + params
    sobj.setAttribute("type", "text/javascript");
    sobj.setAttribute("language", "javascript");
    sobj.setAttribute("src", surl);
    document.body.appendChild(sobj);
}

function #{pre}CollectOS(){
  var operatingSystems = ["","windows","macintosh","linux"];
  PluginScanHostDetails["os"] = operatingSystems[PluginDetect.OS];
  return("os=" + operatingSystems[PluginDetect.OS] + "&");
}

function #{pre}CollectTID(){
  return("tid=#{tid}&");
}

function #{pre}CollectBrowser(){
  if (PluginDetect.isChrome){
    PluginScanHostDetails["br"] = "chrome";
    PluginScanHostDetails["br_v"] = PluginDetect.verChrome;
    return ("br=chrome&br_v=" + PluginDetect.verChrome + "&");
  }
  else if (PluginDetect.isIE){
    PluginScanHostDetails["br"] = "ie";
    PluginScanHostDetails["br_v"] = PluginDetect.verIE;
    return ("br=ie&br_v=" + PluginDetect.verIE + "&");
  }
  else if (PluginDetect.isGecko){
    PluginScanHostDetails["br"] = "firefox";
    PluginScanHostDetails["br_v"] = PluginDetect.verGecko;
    return ("br=firefox&br_v=" + PluginDetect.verGecko + "&");
  }
  else if (PluginDetect.isSafari){
    PluginScanHostDetails["br"] = "safari";
    PluginScanHostDetails["br_v"] = PluginDetect.verSafari;
    return ("br=safari&br_v=" + PluginDetect.verSafari + "&");
  }
  else if (PluginDetect.isOpera){
    PluginScanHostDetails["br"] = "opera";
    PluginScanHostDetails["br_v"] = PluginDetect.verOpera;
    return ("br=opera&br_v=" + PluginDetect.verOpera + "&");
  }
}

function #{pre}CollectPlugins(){
  var plugins = ["AdobeReader","DevalVR","Flash","Java","QuickTime","RealPlayer","Shockwave","SilverLight","WMP","VLC"];
  for (var i in plugins){
    if (PluginDetect.getVersion(plugins[i]) != null){
      #{pre}CollectHostData(plugins[i],PluginDetect.getVersion(plugins[i]))
    }
  }
}

function #{pre}CollectHostData(software,version){
  PluginScanHostDetails[software] = version;
}

function #{pre}CollectParams(){
      var params = "";
      var ao = ["AdobeReader","DevalVR","Flash","Java","QuickTime","RealPlayer","Shockwave","SilverLight","WMP","VLC"];
      var plugins = {
        "AdobeReader":"reader",
        "DevalVR":"dvr",
        "Flash":"flash",
        "Java":"java",
        "QuickTime":"qt",
        "RealPlayer":"rp",
        "Shockwave":"shock",
        "SilverLight":"silver",
        "WMP":"wmp",
        "VLC":"vlc"
        }

	for (var i in ao){
		if (PluginScanHostDetails[ao[i]] != undefined){
			params += plugins[ao[i]] + "=" + PluginScanHostDetails[ao[i]] + "&";
		}
	}
	params += #{pre}CollectOS();
	params += #{pre}CollectBrowser();
	params += #{pre}CollectTID();
	return params;
}
^

    unless $plugin_detect
      plugin_detect_js = ::File.expand_path(::File.join(::File.dirname(__FILE__), "..", "..", "public", "plugin_detect.js"))
      $plugin_detect = ''
      ::File.open(plugin_detect_js, "rb") do |fd|
        $plugin_detect = fd.read(fd.stat.size)
      end
      $plugin_detect << "\n\n"
    end

    plugin_detect = $plugin_detect

    @javascript = collect_code + plugin_detect + "#{pre}CollectPlugins();\n";
    if params[:run].to_i == 1
      @javascript << "#{pre}RunAgent();\n";
    end
    @javascript
  end
end
