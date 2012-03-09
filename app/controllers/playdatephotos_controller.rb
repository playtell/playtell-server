class PlaydatephotosController < ApplicationController
  
  def new
    @playdatePhoto = PlaydatePhoto.new
  end

  def create
    unless params[:playdate_photo][:photo].blank? 
      @playdatePhoto = current_user.playdate_photos.build(params[:playdate_photo])
      @playdatePhoto.save
    end
    respond_to do |format|
      format.js 
    end
  end

end
