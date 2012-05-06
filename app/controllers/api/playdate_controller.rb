class Api::PlaydateController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  #request params expected: playdate_id
  def playdate_players
    p = Playdate.find(params[:playdate_id])
    if p
      render :status=>200, :json=>{:initiator=>User.find(p.player1_id).as_json, :playmate=>User.find(p.player2_id).as_json}
    else
      render :status=>401, :json=>{:message=>"Playdate not found."}
    end
  end
  
  #request params expected: playdate_id and initiator_id
  def redial
    p = Playdate.find(params[:playdate_id])
    initiator = User.find(params[:initiator_id])
    if p.disconnected?
      render :status=>401, :json=>{:message=>"Playdate has ended."}
    elsif !p.hasUser(initiator)
      render :status=>401, :json=>{:message=>"Initiator is not a player in playdate."}     
    else
      playmate = User.find(p.getOtherPlayerID(initiator))
      device_tokens = playmate.device_tokens
      if !device_tokens.blank?
         notification = {
           :device_tokens => [device_tokens.last.token],
           :aps => {
             :alert => "#{initiator.displayName} wants to play!",
             :playdate_url => root_url.to_s + 'playdate?playdate='+p.id.to_s, 
             :initiator => initiator.displayName,
             :initiatorID => initiator.id,
             :playmate => playmate.displayName,
             :playmateID => playmate.id,
             :sound => "music-box.wav" }
         }
         puts "push notification sent with this data: " + "device token: " + notification[:device_tokens][0] + " url: " + notification[:aps][:playdate_url] + " initiator: " + notification[:aps][:initiator] + " playmate: " + notification[:aps][:playmate]
         Urbanairship.push(notification)
         render :status=>200, :json=>{:message=>"Push notification sent to user #{playmate.id.to_s}"}
       else
         render :status=>401, :json=>{:message=>"No device token for user #{playmate.id.to_s}"}
       end
    end
  end
  
end