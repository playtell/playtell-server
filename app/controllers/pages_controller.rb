class PagesController < ApplicationController
  before_filter :authenticate_user!
  layout 'pages'
  
  def show
    @book = Book.find(params[:book_id])
    @page = @book.pages.where(:page_num => params[:id]).first
  end
end