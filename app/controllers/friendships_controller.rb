class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend added!"
      redirect_to user_path current_user
    else
      flash[:error] = "Unable to add friend."
      redirect_to user_path current_user
    end
  end

  def destroy
  end

end
