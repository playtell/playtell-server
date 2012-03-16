class Api::PlaydatephotosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def new
    @playdatePhoto = PlaydatePhoto.new
  end

  # photo will come in with user_id, playdate_id, photo, and counter (num photo taken in the playdate)
  def create
    user_id = params[:user_id]
    #playdate = params[:playdate_photo][playdate_id] #not yet added to the model
    #counter = params[:playdate_photo][:counter]
    photo = params[:photo]
    
#    if request.format != :json
#        render :status=>406, :json=>{:message=>"The request must be json"}
#        return
#    end
    
    if user_id.nil? or photo.blank? 
      render :status=>400, :json=>{:message=>"The request must contain the user_id and photo."}
      return
    end
    
    #user = User.find(user_id)
    
    @playdatePhoto = PlaydatePhoto.new
    @playdatePhoto.user_id = user_id
    @playdatePhoto.photo = photo
    
    respond_to do |format|
      if @playdatePhoto.save
        format.html { redirect_to user_path current_user, flash[:notice] = "Successfully created photo." }
        format.json { render :json => {:photo=>@playdatePhoto}  }
      else
        format.html { redirect_to user_path current_user, flash[:notice] = "Failed to create photo." }
        format.json { render :json => {:message=>"error"}  }
      end
    end
  end

  def create_old
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
      
      #data = StringIO.new(Base64.decode64(params[:photo_data]))
      #data.class.class_eval { attr_accessor :original_filename, :content_type }
      #data.original_filename = "cover.png"
      #data.content_type = "image/png"
      
      #@playdatePhoto = current_user.playdate_photos.new()
      #@playdatePhoto.photo = data
      #@playdatePhoto.save
    end
    render :nothing => true
  end

end
