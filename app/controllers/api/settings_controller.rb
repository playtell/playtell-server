class Api::SettingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:version_check]
  respond_to :json
  
  def edit
    @user = current_user
  end

  def update
    @user = User.find_by_email(params[:user][:email])
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      @user.reset_authentication_token!
      sign_in @user, :bypass => true
      render :status=>200, :json=>{:token=>@user.authentication_token}
    else
      puts @user.errors.full_messages.as_json
      render :status=>401, :json=>{:errors=>@user.errors.full_messages.as_json, :keys=>@user.errors.keys.as_json}
    end
  end

  # required params: version
  # note: this call is not authenticated
  def version_check
    version = params[:version]
    return render :status=>400, :json=>{:message=>"The request must contain the a version number."} if version.blank?

    #check against current major version of app
    v = version.split(".")[0]
    if CURRENT_MAJOR_VERSION.to_i > v.to_i
      render :status=>600, :json=>{:status => "Needs to upgrade to latest major version"}
      return
    end
    render :status=>200, :json=>{:status => "Success"}
  end
end
