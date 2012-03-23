class TwilioController < ApplicationController
  
  #respond_to :xml
  
  def incoming
    response = Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client twilio_name
      end
    end
    render :text => response
  end

end
