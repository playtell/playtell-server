class UsersController < ApplicationController
  layout 'playdates'
  before_filter :authenticate_user!
  before_filter :pusher, :only => [:show]
  layout :chooseLayout
  
  def show
    @user = current_user
    if !@user.confirmed?
      redirect_to ipad_path
    end
    u = current_user
    @new_friends = User.all.select { |friend| friend.id != u.id && u.isFriend?(friend).nil? }
    
    @users = []

    #for playdate
    @feedback = Feedback.new
    @books = Book.all
  
  end
    
  def search
    @users = User.search(params[:search])
  end
  
  # for admin
  def allofplaytellsusers
    @peeps = User.order("id DESC")
    @earlypeeps = EarlyUser.order("id DESC")
    @playdates = Playdate.order("id DESC")
  end
  
  #for admin
  def remove
    @user = User.find(params[:user_id])
    @user.destroy unless @user.blank?
    redirect_to allofplaytellsusers_users_path
  end
  
  #for admin
  def remove_earlyuser
    @user = EarlyUser.find(params[:user_id])
    @user.delete unless @user.blank?
    redirect_to allofplaytellsusers_users_path
  end
  
  def chooseLayout 
    case action_name
    when 'show'
      'playdates'
    else
      'admin'
    end
  end
end
