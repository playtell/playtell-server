class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  
  def index 
    @activities = Activity.all
  end
  
  def new
    @activity = Activity.new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:notice] = "Successfully created book."
      redirect_to activities_path
    else
      render :action => 'new'
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
  
end