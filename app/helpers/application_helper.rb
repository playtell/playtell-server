module ApplicationHelper
  
  def twilio_token
    #Twilio::CapabilityToken.create \
     #   allow_outgoing: 'APabe7650f654fc34655fc81ae71caa3ff' #Twilio::ACCOUNT_SID,
        #allow_incoming: current_user.email  
    Twilio::CapabilityToken.create \
      account_sid:    Twilio::ACCOUNT_SID,
      auth_token:     Twilio::AUTH_TOKEN,
      allow_incoming: twilio_name,
      allow_outgoing: 'AP53bc8a48b98b4da0a5ba8c4b83f5bc69'
  end
  
  def twilio_name
    @current_user.id.to_s
  end
  
end
