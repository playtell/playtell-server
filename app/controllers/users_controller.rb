class UsersController < ApplicationController
  layout 'application'
  before_filter :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    u = current_user
    @new_friends = User.all.select { |friend| friend.id != u.id && u.isFriend?(friend).nil? }
    @users = []
  end
  
  def search
    @users = User.search(params[:search])
  end

end
