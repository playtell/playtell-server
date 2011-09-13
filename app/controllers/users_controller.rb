class UsersController < ApplicationController
  layout 'application'
  before_filter :authorize, :only => [:show]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "New user signed up!"
    else
      render "new"
    end
  end
  
  def show
    u = current_user
    @new_friends = User.all.select { |friend| friend.id != u.id && u.isFriend?(friend).nil? }
    @users = []
  end
  
  def search
    @users = User.search(params[:search])
  end

end
