class BooksController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    if @book.save
      params[:num_pages].to_i.times do |page_num| 
        @book.pages.create({:page_num => page_num+1, 
                           :page_text => ""})
      end
      flash[:notice] = "Successfully created book."
      redirect_to activities_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      if @book.pages.count != params[:num_pages].to_i
        @book.pages.delete_all
        params[:num_pages].to_i.times do |page_num| 
          @book.pages.create({:page_num => page_num+1, 
                             :page_text => ""})
        end
      end
      flash[:notice] = "Successfully updated book."
      redirect_to activities_path
    else
      render :action => 'update'
    end
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
end