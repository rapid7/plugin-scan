class InspectController < ApplicationController
  skip_before_filter :prevent_clickjacking

  def index
    @results = ""

    unless lookup_feed(source.feed_id)
      respond_to :js
      return
    end

    if source.tid.present?
      collect_hit
      get_redirect
      inspection
    end

    respond_to :js
  end

  def source
    @source ||= InspectParameterSource.new(self)
  end

  def collect_hit
    collector = UseCases::SoftwareCollector.new(source)
    collector.collect
    @failures = collector.outdated_versions
  end

  def cookie_value_for(key)
    cookies[key]
  end

  def inspection

    @opts = params[:opts] || "0"

    jsimg = %Q^
      var tdiv = document.getElementById("#{DIV_CONTAINER_ID}");
      var aobj = document.createElement("a");
      var iobj = document.createElement("img");
      aobj.setAttribute("href", "#{BASE_URL}/scanme");
      aobj.setAttribute("border", 0);
      iobj.setAttribute("src", iurl);
      iobj.setAttribute("border", 0);
      aobj.appendChild(iobj);
      if (tdiv) tdiv.appendChild(aobj);
	^

    case params[:w_type].to_i
    when 2
      if @failures.empty?
        @results << %Q^var iurl = "#{BASE_URL}/assets/badge_small_pass.png";\n^ + jsimg
      else
        @results << %Q^var iurl = "#{BASE_URL}/assets/badge_small_fail.png";\n^ + jsimg
      end
    when 3
      if params[:lab].to_i == 1
        get_overlay_code
      elsif not @failures.empty?
        get_overlay_code
      end
    when 4
      if params[:lab].to_i == 1 or @failures.length > 0
        redirect
      end
    end
  end

  def redirect
    @results << "window.location = \"#{@redirect}\";\n"
  end

  def get_overlay_code
	  @results << %Q^
	function pluginScanOverlay(){

    // Load overlay stylesheet
    var cobj  =  document.createElement("link")
    var curl = "#{BASE_URL}/assets/pluginScanOverlay.css"
    cobj.setAttribute("rel", "stylesheet")
    cobj.setAttribute("type", "text/css")
    cobj.setAttribute("href", curl)
    document.body.appendChild(cobj);

    // Create overlay content
    var content = '<div><p><a onclick="pluginScanOverlay();">';
    content += '<img src="#{BASE_URL}/assets/overlay_close.png" border="0">';
    content += '</a><br><a href="#{BASE_URL}/scanme" target="new" border="0" onclick="pluginScanOverlay();">';
    content += '<img src="#{BASE_URL}/assets/badge_overlay.png" border="0"></a></p></div>';

    var overlayDiv = document.createElement("div");
    overlayDiv.innerHTML = content;
    overlayDiv.setAttribute("id","pluginScanOverlay");
    document.body.appendChild(overlayDiv);

    overlay = document.getElementById("pluginScanOverlay");
    overlay.style.visibility = (overlay.style.visibility == "visible") ? "hidden" : "visible";
}

pluginScanOverlay();
^

  end


end
