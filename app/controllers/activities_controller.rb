class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  
  def index 
    @activities = Activity.all
  end
  
  def new
    @activity = Activity.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:notice] = "Successfully created book."
      redirect_to allofplaytellsusers_users_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
end