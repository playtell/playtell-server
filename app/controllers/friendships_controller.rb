class FriendshipsController < ApplicationController
  
  #creates a friendship with the user that is currently logged in
  def create
    fID = params[:friend_id]
    if fID != current_user.id && !Friendship.exists(fID, current_user.id)
      @friendship = current_user.friendships.build(:friend_id => fID)
      if @friendship.save
        flash[:notice] = "Friend added!"
        redirect_to user_path current_user
        return
      end
    end
    flash[:notice] = "Unable to add friend"
    redirect_to user_path current_user
  end
  
  #for admin
  def add
    fID = params[:friend_id]
    uID = params[:user_id]
    if fID != uID && !Friendship.exists(fID, uID) && User.find(fID)
      @friendship = Friendship.new(:friend_id => params[:friend_id], :user_id => params[:user_id])
      if @friendship.save
        flash[:notice] = "Friend added!"
        redirect_to allofplaytellsusers_users_path
        return
      end
    end
    flash[:notice] = "Unable to add friend"
    redirect_to allofplaytellsusers_users_path
  end
  
  def destroy
  end
  
  #for admin
  def remove 
    @friendship = Friendship.find_by_user_id_and_friend_id(params[:user_id], params[:friend_id]) || Friendship.find_by_user_id_and_friend_id(params[:friend_id], params[:user_id])
    @friendship.delete unless @friendship.blank?
    redirect_to allofplaytellsusers_users_path
  end

end
