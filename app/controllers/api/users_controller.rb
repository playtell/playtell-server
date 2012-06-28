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
  
  # required params: user_ids
  def get_status
    # Verify ids
    return render :status => 151, :json => {:message => 'User ids missing'} if params[:user_ids].nil? || params[:user_ids].empty?
    ids = params[:user_ids].split(',').map!{|id| id.to_i};
    return render :status => 151, :json => {:message => 'User ids missing'} if ids.empty?
    
    # Find all users
    user_statuses = {}
    ids.each do |id|
      user = User.find(id)
      return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?
      
      # Check if user is pending, connected or not connected at all
      if Playdate.count(:conditions => ["(player1_id = ? or player2_id = ?) and status = ?", id, id, Playdate::CONNECTING]) > 0
        user_statuses[id] = Playdate::CONNECTING
      elsif Playdate.count(:conditions => ["(player1_id = ? or player2_id = ?) and status = ?", id, id, Playdate::CONNECTED]) > 0
        user_statuses[id] = Playdate::CONNECTED
      else
        user_statuses[id] = Playdate::DISCONNECTED
      end
    end
    
    # Return all statuses
    render :status => 200, :json => {:status => user_statuses}
  end
end
