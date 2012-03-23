class TwilioController < ApplicationController
  
  #respond_to :xml
  
  def incoming
    response = Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client request.request_parameters.clientName
      end
    end
    render :text => response
  end

end
