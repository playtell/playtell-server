class TwilioController < ApplicationController
  
  #respond_to :xml
  
  def incoming
    response = Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client params[:clientName]
      end
    end
    render :text => response
  end
  
  def capability_token
    twilio_token
  end

end
