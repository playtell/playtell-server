class Api::TokensController  < ApplicationController 
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    username = params[:username]
    password = params[:password]
    device_token = params[:device_token] if params[:device_token]
    
    if request.format != :json
        render :status=>406, :json=>{:message=>"The request must be json"}
        return
    end
    
    if username.nil? or password.nil? 
      render :status=>400, :json=>{:message=>"The request must contain the username and password."}
      return
    end
    
    @user=User.find_by_username(username.downcase)
    
    if @user.nil?
      logger.info("User #{username} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid username or passoword."}
      return
    end
    
    @user.ensure_authentication_token!
    #@user.save!
    
    if not @user.valid_password?(password) 
      logger.info("User #{username} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid username or passoword."} 
    else
      if !device_token.blank?
        d = DeviceToken.find_or_create_by_user_id({ :user_id => @user.id })
        if d.token != device_token
          d.token = device_token
          d.save!
          Urbanairship.register_device(params[:device_token])
        end
      end
      render :status=>200, :json=>{:token=>@user.authentication_token, :user_id=>@user.id} 
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
