class UsersController < ApplicationController
  layout 'application'
  before_filter :authenticate_user!
  before_filter :pusher, :only => [:show]
  
  def show
    @user = current_user
    u = current_user
    @new_friends = User.all.select { |friend| friend.id != u.id && u.isFriend?(friend).nil? }
    @users = []
  end
    
  def search
    @users = User.search(params[:search])
  end
  
  # for admin
  def allofplaytellsusers
    @peeps = User.all
    @earlypeeps = EarlyUser.all
    @playdates = Playdate.all
  end
  
  #for admin
  def remove
    @user = User.find(params[:user_id])
    @user.delete unless @user.blank?
    redirect_to allofplaytellsusers_users_path
  end
  
  #for admin
  def remove_earlyuser
    @user = EarlyUser.find(params[:user_id])
    @user.delete unless @user.blank?
    redirect_to allofplaytellsusers_users_path
  end
  

end
