class GamesController < ApplicationController
  before_filter :initOpenTok, :only => [:primoRagatzo, :joinSemira]
  @@opentok = nil
    
  def index
    primo = User.first
    if primo.tokbox_session_id.blank?
      session = @@opentok.create_session '127.0.0.1'  
      @tok_session_id = session.session_id
      primo.tokbox_session_id = @tok_session_id
      primo.save!
    else
      @tok_session_id = primo.tokbox_session_id
    end  
  end
  
  def primoRagatzo
    primo = User.first
    @tok_session_id = primo.tokbox_session_id
    @tok_token = @@opentok.generate_token :session_id => @tok_session_id
    
    respond_to do |format|
      format.html { render("ragatzi.html") }
#      format.js
    end
  end

protected
  def initOpenTok
    if @@opentok.nil?
      @@opentok = OpenTok::OpenTokSDK.new 335312, "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d"
      @@opentok.api_url = 'https://staging.tokbox.com/hl'
    end
    @api_key = "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d"
  end

end
