class Api::FriendshipsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  # Description: create a new friendship request
  # Params: user_id: user_id to friend
  def create
    # Find the user
    return render :status => 150, :json => {:message => "User not found."} if params[:user_id].nil? || params[:user_id].empty?
    user = User.find(params[:user_id].to_i)
    return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?

    # See if they're already confirmed friends
    return render :status => 152, :json => {:message => "User is already a friend."} if current_user.isFriend?(user)

    # See if there's already an open friendship by current_user for the requested user
    friendship = Friendship.where(:user_id => current_user.id, :friend_id => user.id).first
    return render :status => 153, :json => {:message => "Friendship already requested."} unless friendship.nil?

    # See if there's already an open friendship by the requested user for current_user (vice-versa)
    friendship = Friendship.where(:user_id => user.id, :friend_id => current_user.id).first
    unless friendship.nil?
      # If so, make them friends immediately!
      friendship.status = true
      friendship.save

      # TODO: Notify user_id that we confirmed their friend request

      return render :status => 200, :json => {:message => "Friendship accepted"}
    end

    # Create a friendship request
    current_user.friendships.create!(:friend_id => user.id)

    # TODO: Notify user_id of new friendship request

    render :status => 200, :json => {:message => "Friendship request created"}
  end

  # Description: Accept a friendship request
  # Params: user_id: user_id to approve friendship with
  def accept
    # Find the user
    return render :status => 150, :json => {:message => "User not found."} if params[:user_id].nil? || params[:user_id].empty?
    user = User.find(params[:user_id].to_i)
    return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?

    # Find this friendship request (must be neither declined nor an accepted request)
    friendship = user.friendships.where("friendships.friend_id = #{current_user.id} and friendships.status is null").first
    return render :status => 154, :json => {:message => "Friendship request not found."} if friendship.nil?

    # Accept friendship
    friendship.status = true
    friendship.save

    # TODO: Notify user_id of friendship acceptance

    render :status => 200, :json => {:message => "Friendship accepted"}
  end

  # Description: Decline a friendship request
  # Params: user_id: user_id to deny friendship from
  def decline
    # Find the user
    return render :status => 150, :json => {:message => "User not found."} if params[:user_id].nil? || params[:user_id].empty?
    user = User.find(params[:user_id].to_i)
    return render :status => 150, :json => {:message => "User {#{id}} not found."} if user.nil?

    # Find this friendship request (must be neither declined nor an accepted request)
    friendship = user.friendships.where("friendships.friend_id = #{current_user.id} and friendships.status is null").first
    return render :status => 154, :json => {:message => "Friendship request not found."} if friendship.nil?

    # Decline friendship
    friendship.status = false
    friendship.save

    # TODO: Notify user_id of friendship denial 

    render :status => 200, :json => {:message => "Friendship declined"}
  end

end