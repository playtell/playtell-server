class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  
  def index 
    @activities = Activity.all
  end
  
  def new
  end
  
  def newactivity
    @activity = Activity.new
    if params[:activity_type] == "book" 
      @activity.create_book
      render 'newbook'
    else
      @activity.create_game
    end   
  end
  
  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      flash[:notice] = "Successfully created activity."
      redirect_to activities_path
    else
      render :action => 'newactivity'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
    if !@activity.book.blank?
      redirect_to edit_book_path(@activity.book)
      return
    end
  end
  
  def update
    @activity = Activity.find(params[:id])
    if !@activity.book.blank?
      redirect_to update_book_path(@activity.book)
      return
    end
    
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "Successfully updated activity."
      redirect_to activities_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @activity = Activity.find(params[:id])
    if !@activity.book.blank?
      redirect_to book_path(@activity.book)
      return
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = "Successfully deleted activity."
    redirect_to activities_path
  end
  
end