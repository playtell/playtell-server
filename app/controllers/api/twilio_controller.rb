class Api::TwilioController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :only => [:capability_token]
  respond_to :json

  def incoming
    response = Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client params[:clientName]
      end
    end
    render :text => response
  end
  
  def capability_token
    puts current_user.username
    token = Twilio::CapabilityToken.create \
              account_sid:    Twilio::ACCOUNT_SID,
              auth_token:     Twilio::AUTH_TOKEN,
              allow_incoming: twilio_name,
              allow_outgoing: 'AP53bc8a48b98b4da0a5ba8c4b83f5bc69' 
    render :json=>{:token=>token} 
  end
  
private
  def twilio_name
    current_user.id.to_s
  end

end
