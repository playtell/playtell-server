class PlaydatephotosController < ApplicationController
 
  def new
    @playdatePhoto = PlaydatePhoto.new
  end

  def create_old
    unless params[:playdate_photo][:photo].blank? 
      @playdatePhoto = current_user.playdate_photos.build(params[:playdate_photo])
      @playdatePhoto.save
    end
    respond_to do |format|
      format.js 
    end
  end

  def create
    unless params[:photo_data].blank? 
      #kit = IMGKit.new(params[:photo_data])
      #file = kit.to_file('tmp/uploads/test.png') 
      #file = kit.to_file('public/images/photos/test.png') 
      
      #File.open('public/images/photos/test.gif', 'wb') do |f|
      #  f.write(Base64.decode64(params[:photo_data]))
      #end
      
      #img = Magick::Image.from_blob(params[:photo_data]) {
      #  self.format = "png"
      #}
      #puts img.write('public/images/photos/test.png', 'png')
      
      data = StringIO.new(Base64.decode64(params[:photo_data]))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "cover.png"
      data.content_type = "image/png"
      
      @playdatePhoto = current_user.playdate_photos.new()
      @playdatePhoto.photo = data
      @playdatePhoto.save
    end
    render :nothing => true
  end

end
