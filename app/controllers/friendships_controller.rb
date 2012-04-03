class FriendshipsController < ApplicationController
  
  #creates a friendship with the user that is currently logged in
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend added!"
      redirect_to user_path current_user
    else
      flash[:error] = "Unable to add friend"
      redirect_to user_path current_user
    end
  end
  
  def add
    @friendship = Friendship.new(:friend_id => params[:friend_id], :user_id => params[:user_id])
    if @friendship.save
      flash[:notice] = "Friend added!"
      redirect_to allofplaytellsusers_users_path
    else
      flash[:error] = "Unable to add friend"
      redirect_to allofplaytellsusers_users_path
    end
  end
  
  def destroy
  end
  
  def remove 
    @friendship = Friendship.find_by_user_id_and_friend_id(params[:user_id], params[:friend_id])
    @friendship.delete unless @friendship.blank?
    redirect_to allofplaytellsusers_users_path
  end

end
