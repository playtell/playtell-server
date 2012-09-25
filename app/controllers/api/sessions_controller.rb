class Api::SessionsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:create]
  respond_to :json
  
  def create
    build_resource
    resource = User.find_for_database_authentication(:login=>params[:email])
    return render :status => 155, :json => {:message => "Invalid email"} unless resource

    if resource.valid_password?(params[:password])
      sign_in("user", resource)
      return render :status => 200, :json => {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
    end
    
    render :status => 156, :json => {:message => "Invalid password"}
  end
end
