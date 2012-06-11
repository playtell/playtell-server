class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  # required params: user_id
  # returns user objects for all of the given user's friends
  def all_friends
    u = User.find(params[:user_id])
    
    if !u or u.blank?
      render :status=>150, :json=>{ :message => "User not found." }
      return
    else
      response = u.allFriends
    end
    render :status=>200, :json=>{:friends => response}
  end
end
