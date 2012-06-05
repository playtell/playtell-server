class Api::BooksController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  def list
    books = Book.order(:created_at).all
    response = []
    books.each do |book|
      response << {
        :id           => book.id,
        :current_page => 1,
        :cover_front  => url_for(book_url(book)),
        :pages        => book.pages.order(:page_num).map{|page| url_for(book_page_url(book, page.page_num))},
        :total_pages  => book.pages.size
      }
    end

    render :status=>200, :json=>{:books => response}
  end
end