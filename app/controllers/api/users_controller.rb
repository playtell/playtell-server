class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  # required params: user_id
  # returns user objects for all of the given user's friends
  def all_friends
    u = User.find(params[:user_id])
    return render :status=>150, :json=>{ :message => "User not found." } if u.nil?

    # Give each friendship a status (confirmed, pending-them, or pending-you)
    friends = []
    u.allApprovedAndPendingFriendships.each do |friendship|
      # Figure out status
      status = friendship.status.nil? ? 'pending' : 'confirmed'
      
      # Find friend
      if friendship.user_id == current_user.id
        friend_id = friendship.friend_id
        status = "pending-them" if status == 'pending' # Are we waiting for them to approve to you to approve?
      else
        friend_id = friendship.user_id
        status = "pending-you" if status == 'pending' # Are we waiting for them to approve to you to approve?
      end

      friend = User.find(friend_id)
      next if friend.nil?

      # Find friend friendship status
      friendHash = friend.as_json
      friendHash[:friendship_status] = status
      friends << friendHash
    end
    
    render :status=>200, :json=>{:friends => friends}
  end
  
  # required params: user_ids
  def get_status
    # Verify ids
    return render :status => 151, :json => {:message => 'User ids missing'} if params[:user_ids].nil? || params[:user_ids].empty?
    ids = params[:user_ids].split(',').map!{|id| id.to_i};
    return render :status => 151, :json => {:message => 'User ids missing'} if ids.empty?
    
    # Find all users
    user_statuses = []
    ids.each do |id|
      user = User.find(id)
      return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?
      
      # Check status
      if (user.status != User::CONFIRMED)
        # User is pending (aka. hasn't installed the app yet)
        user_statuses << {:id => id, :status => 'pending'}
      elsif Playdate.count(:conditions => ["(player1_id = ? or player2_id = ?) and status != ?", id, id, Playdate::DISCONNECTED]) > 0
        # User is either connecting to a playdate or in a playdate
        user_statuses << {:id => id, :status => 'playdate'}
      else
        # User is available
        user_statuses << {:id => id, :status => 'available'}
      end
    end
    
    # Return all statuses
    render :status => 200, :json => {:status => user_statuses}
  end

  # DEPRECIATED: Reimplemented in api/friendships_controller.rb > 'create'
  # require params: user_id
  # def create_friendship
  #   # Find the user
  #   return render :status => 150, :json => {:message => "User not found."} if params[:user_id].nil? || params[:user_id].empty?
  #   user = User.find(params[:user_id].to_i)
  #   return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?

  #   # See if they're already friends
  #   return render :status => 152, :json => {:message => "User is already a friend."} if current_user.isFriend?(user)

  #   # Create friendship with current user
  #   current_user.friendships.create!(:friend_id => user.id)

  #   render :status => 200, :json => {:message => "Friendship created"}
  # end
end