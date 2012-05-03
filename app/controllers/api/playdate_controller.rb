class Api::PlaydateController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  def playdate_players
    p = Playdate.find(params[:playdate_id])
    if p
      render :status=>200, :json=>{:initiator=>User.find(p.player1_id).as_json, :playmate=>User.find(p.player2_id).as_json}
    else
      render :status=>401, :json=>{:message=>"Playdate not found."}
    end
    
  end
  
end