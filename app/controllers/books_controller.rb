class BooksController < ApplicationController
  before_filter :authenticate_user!
  layout 'books'
  
  def show
    @book = Book.find(params[:id])
  end
  
end