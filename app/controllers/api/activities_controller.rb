class Api::ActivitiesController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def list
    a = Activity.order(:position).all

    response = []
    a.each do |activity| 
      next if activity.book.blank?
      
      pages = []
      book = activity.book
      book.pages.order(:page_num).each do |page|
          pages << {
            :url    => url_for(book_page_url(book, page.page_num)),
            #:bitmap => "http://playtell.s3.amazonaws.com/books/#{book.id.to_s}/page#{page.page_num.to_s}.jpg"
            :bitmap => "#{S3_BUCKET_NAME}/books/#{book.image_directory}/page#{page.page_num.to_s}"
          }
      end
      response << {
        :activity_id  => activity.id,
        :book_id      => book.id,
        :current_page => 1,
        :cover        => {
            :front => {
            :url    => url_for(book_url(book)),
            :bitmap => "#{S3_BUCKET_NAME}/books/#{book.image_directory}/cover_front"
            }
        },
        :pages        => pages,
        :total_pages  => book.pages.size
      }
    end
    
    render :status=>200, :json=>{:activities => a, :books => response}
  end
    
end