class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:create]
  respond_to :json

  # required params: name, email, password, photo, birthdate, isAccountForChild
  def create
    # Create the user
    user = User.new
    user.username = params[:name]
    user.email = params[:email]
    user.password = params[:password]
    puts user.inspect

    if !user.save
      puts user.errors.inspect
      return render :status => 153, :json => {:message => "User cannot be created at this time."}
    end

    # Upload profile photo
    profilePhoto = PlaydatePhoto.new(:user_id => user.id)
    profilePhoto.photo = params[:photo]
    puts profilePhoto.inspect
    
    if !profilePhoto.save
      puts profilePhoto.errors.inspect
      return render :status => 154, :json => {:message => "User photo cannot be created at this time."}
    end

    render :status => 200, :json => {:message => "User created #{user.id}"}
  end

  # required params: user_id
  # returns user objects for all of the given user's friends
  def all_friends
    u = User.find(params[:user_id])
    return render :status=>150, :json=>{ :message => "User not found." } if u.nil?

    # Give each friendship a status (confirmed, pending-them, or pending-you)
    # Give each a user status (available, playdate, pending)
    friends = []
    u.allApprovedAndPendingFriendships.each do |friendship|
      # # Friendship status
      # friendshipStatus = friendship.status.nil? ? 'pending' : 'confirmed'
      if friendship.user_id == current_user.id
        friend_id = friendship.friend_id
      #   friendshipStatus = "pending-them" if friendshipStatus == 'pending' # Are we waiting for them to approve to you to approve?
      else
        friend_id = friendship.user_id
      #   friendshipStatus = "pending-you" if friendshipStatus == 'pending' # Are we waiting for them to approve to you to approve?
      end

      # # Find the user
      friend = User.find(friend_id)
      next if friend.nil?

      # # User status
      # if (friend.status != User::CONFIRMED)
      #   # User is pending (aka. hasn't installed the app yet)
      #   userStatus = 'pending'
      # elsif Playdate.count(:conditions => ["(player1_id = ? or player2_id = ?) and status != ?", friend_id, friend_id, Playdate::DISCONNECTED]) > 0
      #   # User is either connecting to a playdate or in a playdate
      #   userStatus = 'playdate'
      # else
      #   # User is available
      #   userStatus = 'available'
      # end

      # # Privacy concern: only show that user is in playdate if you're confirmed friends
      # if userStatus == 'playdate' && friendshipStatus != 'confirmed'
      #   userStatus = 'available'
      # end

      # # Find friend friendship status
      # friendHash = friend.as_json
      # friendHash[:friendshipStatus] = friendshipStatus
      # friendHash[:userStatus] = userStatus
      friendHash = friend.as_playmate(friendship)
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
      elsif Playdate.count(:conditions => ["(player1_id = ? or player2_id = ?) and status != ? and !(player1_id = ? or player2_id = ?)",
        id, id, Playdate::DISCONNECTED, current_user.id, current_user.id]) > 0
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