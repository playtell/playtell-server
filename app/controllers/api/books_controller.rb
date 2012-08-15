class Api::BooksController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  def list
    render :status=>200, :json=>{:books => getBookList}
  end
  
  # returns the id of the puppet book that we're using for the new user experience
  def get_nux_book
    b = Book.find_by_title("Koda's Adventure") 
    if !b.nil?
      render :status=>200, :json => {:nux_bookID => b.id.to_i } 
      return
    end
    render :json => {:message => "no nux book found "}
  end
    
end