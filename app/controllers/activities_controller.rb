class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  
  def index 
    @activities = Activity.order(:toybox_order).all
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
      render 'newgame'
    end   
  end
  
  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      flash[:notice] = "Successfully created activity."
      redirect_to activities_path
    else
      render :action => 'newactivity', :activity_type => params[:activity_type]
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
    if !@activity.book.blank?
      render 'editbook'
    else
      render 'editgame'
    end
  end
  
  def update
    @activity = Activity.find(params[:id])
    
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "Successfully updated activity."
      redirect_to activities_path
    else
      render :action => 'edit'
    end
  end
  
  def editorder
    @activities = Activity.order(:toybox_order).all
  end
  
  def updateorder
    
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = "Successfully deleted activity."
    redirect_to activities_path
  end
  
end