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

    # See if they're already friends
    return render :status => 152, :json => {:message => "User is already a friend."} if current_user.isFriend?(user)

    # Create a friendship request
    current_user.friendships.create!(:friend_id => user.id)

    # TODO: Notify user_id of new friendship request

    render :status => 200, :json => {:message => "Friendship request created"}
  end

  # TODO
  # Description: Approve a friendship request
  # Params: user_id: user_id to approve friendship with
  def approve
  end

  # TODO
  # Description: Deny a friendship request
  # Params: user_id: user_id to deny friendship from
  def deny
  end

end