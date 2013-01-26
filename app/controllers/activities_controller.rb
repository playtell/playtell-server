class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'activities'
  
  def index 
    @activities = Activity.order(:position).all
  end
  
  def new
  end
  
  def newactivity
    @activity = Activity.new
    if params[:activity_type] == "book" 
      @activity.create_book(:image_only => 1)
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
  
  def sort
    @activities = Activity.all
    @activities.each do |a|
      a.position = params['activity'].index(a.id.to_s) + 1
      a.save
    end
    
    render :nothing => true
    end
  
  def reorder_toybox
    
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:notice] = "Successfully deleted activity."
    redirect_to activities_path
  end
  
end