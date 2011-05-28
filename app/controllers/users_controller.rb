class UsersController < ApplicationController
  layout 'games'
  before_filter :authorize
  
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
    @user = User.find(params[:id])
    @players = User.all
  end

end
