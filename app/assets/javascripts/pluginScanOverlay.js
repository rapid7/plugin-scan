function pluginScanOverlay(url){

    // Load overlay stylesheet
    var cobj  =  document.createElement("link")
    var curl = url + "/assets/pluginScanOverlay.css"
    cobj.setAttribute("rel", "stylesheet")
    cobj.setAttribute("type", "text/css")
    cobj.setAttribute("href", curl)
    document.body.appendChild(cobj);

    // Create overlay content
    var content = '<div><p><a onclick="pluginScanOverlay();">';
    content += '<img src="' + url + '"/assets/overlay_close.png" border="0">';
    content += '</a><br><a href=' + url + '/scanme" target="new" border="0" onclick="pluginScanOverlay();">';
    content += '<img src="' + url + '/assets/badge_overlay.png" border="0"></a></p></div>';

    var overlayDiv = document.createElement("div");    
    overlayDiv.innerHTML = content;
    overlayDiv.setAttribute("id","pluginScanOverlay");
    document.body.appendChild(overlayDiv);

    overlay = document.getElementById("pluginScanOverlay");
    overlay.style.visibility = (overlay.style.visibility == "visible") ? "hidden" : "visible";
}
