class Api::BooksController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  def list
    books = Book.order(:created_at).all
    response = []
    books.each do |book|
      pages = []
      book.pages.order(:page_num).each do |page|
        pages << {
          :url    => url_for(book_page_url(book, page.page_num)),
          #:bitmap => "http://playtell.s3.amazonaws.com/books/#{book.id.to_s}/page#{page.page_num.to_s}.jpg"
          :bitmap => "#{S3_BUCKET_NAME}/books/#{book.image_directory}/page#{page.page_num.to_s}.jpg"
        }
      end
      
      response << {
        :id           => book.id,
        :current_page => 1,
        :cover        => {
          :front => {
            :url    => url_for(book_url(book)),
            :bitmap => "#{S3_BUCKET_NAME}/books/#{book.image_directory}/cover_front.jpg"
          }
        },
        :pages        => pages,
        :total_pages  => book.pages.size
      }
    end

    render :status=>200, :json=>{:books => response}
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