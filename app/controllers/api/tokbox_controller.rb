class Api::TokboxController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :only => [:capability_token]
  respond_to :json
  
  def tokbox_tokens
    @playdate = Playdate.find(params[:playdate])
    if @playdate.blank?
      render :json=>{:message => "Playdate not found."}
      return
    else
      render :json=>{:session_id=>@playdate.video_session_id,
                   :initiator_id=>@playdate.player1_id,
                   :initiator_token=>@playdate.tokbox_initiator_token,
                   :playmate_id=>@playdate.player2_id,                   
                   :playmate_token=>@playdate.tokbox_playmate_token} 
    end
  end

end
