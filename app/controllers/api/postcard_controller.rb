class Api::PostcardController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

    # given a user_id, return a list of all photos
    def num_new_photos

      render :status=>200, :json => {:num_photos => 3}

    end
  
  # given a user_id, return a list of all photos
  def all_photos
    
    render :status=>200, :json => [{"postcard"=>{"created_at"=>"2012-08-01T22:49:02Z","id"=>13,"photo"=>{"url"=>"http://playtell.s3.amazonaws.com/all_assets/Postcard%20View/postcards-a.png"},"updated_at"=>"2012-08-01T22:49:02Z","sender_id"=>13}},
{"postcard"=>{"created_at"=>"2012-08-01T22:49:02Z","id"=>13,"photo"=>{"url"=>"http://playtell.s3.amazonaws.com/all_assets/Postcard%20View/postcards-b.png"},"updated_at"=>"2012-08-01T22:49:02Z","sender_id"=>13}},
{"postcard"=>{"created_at"=>"2012-08-01T22:49:02Z","id"=>13,"photo"=>{"url"=>"http://playtell.s3.amazonaws.com/all_assets/Postcard%20View/postcards-c.png"},"updated_at"=>"2012-08-01T22:49:02Z","sender_id"=>13}}]
    
  end

end
