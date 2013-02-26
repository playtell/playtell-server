class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:create, :email_check, :sign_in]
  respond_to :json

  # required params: name, email, password, photo, birthdate, isAccountForChild
  def create
    # Create the user
    user = User.new
    user.username = params[:name]
    user.email = params[:email]
    user.password = params[:password]
    #user.birthday = Date.strptime(params[:birthday], "%Y-%m-%d") 
    user.birthday = params[:birthday]
    
    if !user.save
      puts user.errors.inspect
      return render :status => 153, :json => {:message => "User cannot be created at this time."}
    end

    # Upload profile photo
    profilePhoto = ProfilePhoto.new(:user_id => user.id)
    profilePhoto.photo = params[:photo]

    if !profilePhoto.save
      return render :status => 154, :json => {:message => "User photo cannot be created at this time."}
    end

    # Check if someone invited this user to PlayTell
    # If so, make a joint friendship between them
    contactNotification = ContactNotification.where("email = ?", user.email).order('created_at desc').first
    unless contactNotification.nil?
      friend = User.find(contactNotification.user_id)
      unless friend.nil?
        # Create a new friendship
        friendship = Friendship.new
        friendship.user_id = friend.id
        friendship.friend_id = user.id
        friendship.status = true
        friendship.responded_at = DateTime.now
        friendship.save
        
        # Notify Pusher rendezvous channel of friendship approved
        Pusher["presence-rendezvous-channel"].trigger('friendship_accepted', {
          :initiatorID => friend.id,
          :friendID    => user.id
        })
        
        # Log analytics event
        @mixpanel.track("Friendship Accepted",
          :distinct_id => user.username,
          :user_id => user.id,
          :friend_username => friend.username,
          :friend_id => friend.id)
      end
    end

    render :status => 200, :json => {:message => "User created #{user.id}"}
  end
  
  # required params: user_id, user=>{<user params to update>}
  # use for updating all fields except password
  def update
    if params[:user_id].nil? or params[:user_id].empty?
      return render :status => 400, :json => {:message => 'User_id is missing'} 
    end
    
    user = User.find(params[:user_id])
    
    # Replace profile photo
    if !params[:user][:photo].blank?
      profilePhoto = ProfilePhoto.new(:user_id => user.id)
      profilePhoto.photo = params[:user][:photo]

      if !profilePhoto.save
        return render :status => 154, :json => {:message => "User photo cannot be created at this time."}
      end
    end
        
    if user.update_attributes(params[:user])
      puts user.errors.inspect
      return render :status => 200, :json => {:message => "User updated #{user.id}", :profile_photo => user.profile_photo}
    end
    return render :status => 400, :json => {:message => "User cannot be updated at this time.", :details => user.errors.inspect}
  end
  
  def show
    if params[:user_id].nil? or params[:user_id].empty?
      return render :status => 400, :json => {:message => 'User id missing'} 
    end
    
    user = User.find(params[:user_id])
    return render :status => 200, :json => {:user => user}
  end
  
  # required params: user_id, user=>{:current_password=>"", :password=>""}
  def change_password
    if params[:user_id].nil? or params[:user_id].empty?
      return render :status => 400, :json => {:message => 'User id missing'} 
    end
    
    user = User.find(params[:user_id])
    if user.update_with_password(params[:user])
      puts user.errors.inspect
      return render :status => 200, :json => {:message => "User password updated #{user.id}"}
    end
    return render :status => 400, :json => {:message => "User password cannot be updated at this time.", :details => user.errors.inspect}
    
  end

  # required params: user_id
  # returns user objects for all of the given user's friends
  def all_friends
    u = User.find(params[:user_id])
    return render :status => 150, :json => {:message => "User not found."} if u.nil?

    # Give each friendship a status (confirmed, pending-them, or pending-you)
    # Give each a user status (available, playdate, pending)
    friends = []
    u.allApprovedAndPendingFriendships.each do |friendship|
      # Friendship status
      if friendship.user_id == current_user.id
        friend_id = friendship.friend_id
      else
        friend_id = friendship.user_id
      end

      # Find the user
      begin
        friend = User.find(friend_id)
      rescue ActiveRecord::RecordNotFound => e
        # Delete friendship if friend is not found!
        friendship.destroy
        next
      end

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

  # required params: email
  def email_check
    user = User.find_by_email(params[:email])

    # Return user's id?
    if !user.nil? && !params[:return_user].nil? && params[:return_user] == 'true'
      return render :status => 200, :json => {:available => false, :user_id => user.id}
    end
    
    render :status => 200, :json => {:available => user.nil?}
  end

end