class Api::SettingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      token = @user.reset_authentication_token!
      sign_in @user, :bypass => true
      render :status=>200, :json=>{:token=>token}
    else
      puts @user.errors.full_messages.as_json
      render :status=>401, :json=>{:errors=>@user.errors.full_messages.as_json, :keys=>@user.errors.keys.as_json}
    end
  end
end