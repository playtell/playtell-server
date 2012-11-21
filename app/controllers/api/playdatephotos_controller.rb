class Api::PlaydatephotosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  #s3_access_policy :public_read,:authenticated_read_write
  
  def new
    @playdatePhoto = PlaydatePhoto.new
  end

  # photo will come in with user_id, playdate_id, photo 
  def create
    user_id = params[:user_id]
    playdate_id = params[:playdate_id] 
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
    
    @playdatePhoto = PlaydatePhoto.new(:user_id => user_id, :playdate_id => playdate_id)
    @playdatePhoto.photo = photo

    if @playdatePhoto.save
      render :status=>200, :json=>{:photo=>@playdatePhoto}
    else
      puts @playdatePhoto.errors.inspect
      render :status=>400, :json=>{:message=>"Error saving photo"}
    end
  
  end
  
  # given a user_id, return a list of all photos
  def all_photos
    user_id = params[:user_id]

    if user_id.nil?
      render :status=>400, :json=>{:message=>"The request must contain the user_id."}
      return
    end

    u = User.find(user_id)
    if u.nil?
      logger.info("User with email #{email} failed signin: user cannot be found.")
      render :status=>401, :json=>{:message=>"User cannot be found."}
      return
    end
    
    render :status=>200, :json=>{:all_photos=>u.playdate_photos}

  end

end
