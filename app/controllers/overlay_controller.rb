class OverlayController < InspectController

  def index
    unless lookup_feed(params[:fid])
      render :text => ""
    end

    get_overlay_code

    respond_to do |format|
      format.js
    end
  end
end
