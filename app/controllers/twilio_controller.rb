class TwilioController < ApplicationController
  
  #respond_to :xml
  
  def incoming
    response = Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client current_user.username + current_user.id.to_s
      end
    end
    render :text => response
  end

end
