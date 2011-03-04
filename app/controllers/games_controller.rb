class GamesController < ApplicationController
  
  def index
    config_opentok 
    id = @opentok.create_session '127.0.0.1'  
    @tok_session_id = id.to_s 
    @tok_token = @opentok.generate_token :session_id => @tok_session_id
  end
  
  # function to initialize the opentok object 
  def config_opentok 
    if @opentok.nil? 
      @opentok = OpenTok::OpenTokSDK.new 335312, "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d" 
      @opentok.api_url = 'https://staging.tokbox.com/hl' 
    end 
  end
end
