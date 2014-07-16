class OsController < ApplicationController
 # before_filter :authenticate_user!

  def index
    @os, @br, @br_v = os_details
  end

end
