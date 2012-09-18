class Api::PusherController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def hook
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        if event["name"] == 'channel_vacated'
          # Everyone vacated the channel, mark this playdate as 'disconnected'
          mark_playdate_ended(event["channel"])
        end
      end
      render :json => {response: 'ok'}
    else
      render :status => 401, :json => {response: 'invalid'}
    end
  end
  
  private
  def mark_playdate_ended(channel)
    # Find playdate
    playdate = Playdate.find_by_pusher_channel_name(channel)
    return if playdate.nil?
    
    # If already maked as disconnected, skip
    return if playdate.disconnected?
    
    # Mark as disconnected
    playdate.disconnect
    
    # Send notification of playdate-end via rendesvous channel
    initiator = User.find(playdate.player1_id)
    playmate = User.find(playdate.player2_id)
    Pusher["presence-rendezvous-channel"].trigger('playdate_ended', {
      :playdateID           => playdate.id,
      :pusherChannelName    => playdate.pusher_channel_name,
      :initiatorID          => initiator.id,
      :initiator            => initiator.username,
      :playmateID           => playmate.id,
      :playmateName         => playmate.username,
      :tokboxSessionID      => playdate.video_session_id,
      :tokboxInitiatorToken => playdate.tokbox_initiator_token,
      :tokboxPlaymateToken  => playdate.tokbox_playmate_token
    })
  end
end