class TwilioController < ApplicationController

  def incoming
    Twilio::TwiML.build do |res|
      res.dial do |g|
        g.client current_user.email
      end
    end
  end

end
