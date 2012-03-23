module ApplicationHelper
  
  def twilio_token
    #Twilio::CapabilityToken.create \
     #   allow_outgoing: 'APabe7650f654fc34655fc81ae71caa3ff' #Twilio::ACCOUNT_SID,
        #allow_incoming: current_user.email  
    Twilio::CapabilityToken.create \
      account_sid:    Twilio::ACCOUNT_SID,
      auth_token:     Twilio::AUTH_TOKEN,
      allow_incoming: current_user.email,
      allow_outgoing: Twilio::ACCOUNT_SID
  end
  
end
