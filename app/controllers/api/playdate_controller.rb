class Api::PlaydateController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  before_filter :initOpenTok, :only => [:create]
  respond_to :json
  
  @@opentok = nil
  
  #request params expected: friend_id
  def create
    # Create new Playdate
    video_session = @@opentok.create_session '127.0.0.1'  
    tok_session_id = video_session.session_id
    
    # Verify friend
    playmate = User.find(params[:friend_id].to_i)
    return render :status=>110, :json=>{:message=>"Playmate not found."} if playmate.nil?
    
    # TODO: Check if friends

    # put the playdate in the db and its id in the session
    @playdate = Playdate.find_or_create_by_player1_id_and_player2_id_and_video_session_id(
      :player1_id => current_user.id, 
      :player2_id => playmate.id,
      :video_session_id => tok_session_id,
      :tokbox_initiator_token => @@opentok.generate_token(:session_id => tok_session_id),
      :tokbox_playmate_token => @@opentok.generate_token(:session_id => tok_session_id))
      
    session[:playdate] = @playdate.id # TODO: Needed?
    
    # Send the invite
    Pusher["presence-rendezvous-channel"].trigger('playdate_requested', {
      :playdateID => @playdate.id,
      :pusherChannelName => @playdate.pusher_channel_name,
      :initiator => current_user.username,
      :initiatorID => current_user.id,
      :playmateID => playmate.id,
      :playmateName => playmate.username,
      :tokboxSessionID => @playdate.video_session_id,
      :tokboxInitiatorToken => @playdate.tokbox_initiator_token,
      :tokboxPlaymateToken => @playdate.tokbox_playmate_token }
    )
    
    device_tokens = playmate.device_tokens
    if !device_tokens.blank?
       notification = {
         :device_tokens => [device_tokens.last.token],
         :aps => {
           :alert => "#{current_user.username} wants to play!",
           :playdate_url => root_url.to_s + 'playdate?playdate='+@playdate.id.to_s, #"http://www.playtell.com/playdate?playdate="+@playdate.id.to_s,
           :initiator => current_user.username,
           :initiatorID => current_user.id,
           :playmate => playmate.username,
           :playmateID => playmate.id,
           :sound => "music-box.wav"
         }
       }
       # puts "push notification sent with this data: " + "device token: " + notification[:device_tokens][0] + " url: " + notification[:aps][:playdate_url] + " initiator: " + notification[:aps][:initiator] + " playmate: " + notification[:aps][:playmate]
       Urbanairship.push(notification)
     end
     
     # Notify
     render :status=>200, :json=>{:playdateID => @playdate.id,
       :pusherChannelName => @playdate.pusher_channel_name,
       :initiatorID => current_user.id,
       :playmateID => playmate.id,
       :tokboxSessionID => @playdate.video_session_id,
       :tokboxInitiatorToken => @playdate.tokbox_initiator_token,
       :tokboxPlaymateToken => @playdate.tokbox_playmate_token}
  end

  # required params: playdate_id
  def join
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      return render :status=>100, :json=>{ :message => "Playdate not found." }
    elsif @playdate.disconnected?
      return render :status=>101, :json=>{ :message=> "Playdate has ended." }
    end
    
    # Mark playdate as connected
    @playdate.connected
    
    # Find playmate and notify via pusher
    initiator = @playdate.getOtherPlayer(current_user)
    
    # Send pusher notification
    Pusher["presence-rendezvous-channel"].trigger('playdate_joined', {
      :playdateID => @playdate.id,
      :pusherChannelName => @playdate.pusher_channel_name,
      :initiatorID => initiator.id,
      :initiator => initiator.username,
      :playmateID => current_user.id,
      :playmateName => current_user.username,
      :tokboxSessionID => @playdate.video_session_id,
      :tokboxInitiatorToken => @playdate.tokbox_initiator_token,
      :tokboxPlaymateToken => @playdate.tokbox_playmate_token }
    )
    
    # JSON reply
    render :status=>200, :json=>{:message => "Playdate connected. Sent join notification to playmate '#{initiator.username}' via pusher on #{@playdate.pusher_channel_name}"}
  end
  
  # required params: playdate_id
  def disconnect
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>101, :json=>{ :message=> "Playdate has ended." }
      return
    else
      endPlaydate
    end
    render :status=>200, :json=>{:message => 'End_playdate sent via pusher on '+ @playdate.pusher_channel_name}
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
  
  #request params expected: playdate_id
  def playdate_players
    p = Playdate.find(params[:playdate_id])
    if p
      render :status=>200, :json=>{:initiator=>User.find(p.player1_id).as_json, :playmate=>User.find(p.player2_id).as_json}
    else
      render :status=>401, :json=>{:message=>"Playdate not found."}
    end
  end
  
  # required params: playdate_id, book_id, page_num
  def change_book
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>103, :json=>{ :message=> "Playdate has ended." }
      return
    else
      @playdate.change = Playdate::CHANGE_BOOK
      @playdate.save
      if !changeBook
        render :status=>120, :json=>{ :message=> "Book not found." }
        return
      end
      render :status=>200, :json=>{:message => 'Change_book sent via pusher on '+ @playdate.pusher_channel_name }           
    end
  end
  
  # required params: playdate_id, new_page_num
  def turn_page
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>101, :json=>{ :message=> "Playdate has ended." }
      return
    else
      @playdate.change = Playdate::TURN_PAGE
      @playdate.save
      turnPage
      render :status=>200, :json=>{ :message => 'Turn_page sent via pusher on ' + @playdate.pusher_channel_name } 
    end
  end
  
  # required params: playdate_id, book_id
  def close_book
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>101, :json=>{ :message=> "Playdate has ended." }
      return
    else
      @playdate.change = Playdate::CLOSE_BOOK
      @playdate.save
      closeBook
      render :status=>200, :json=>{:message => 'Close_book sent via pusher on ' + @playdate.pusher_channel_name}
    end
  end
  
  # required params: playdate_id, x, y
  def finger_tap
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>101, :json=>{ :message=> "Playdate has ended." }
      return
    elsif params[:x].blank? or params[:y].blank?
      render :status=>160, :json=>{ :message => "x and y coordinates cannot be blank. "}
      return
    else
      @playdate.change = Playdate::GRANDMA_FINGER
      @playdate.save
      Pusher[@playdate.pusher_channel_name].trigger('finger_tap', {:player => current_user.id, :x => params[:x], :y => params[:y]})
      render :status=>200, :json=>{:message => 'Finger_tap sent via pusher on ' + @playdate.pusher_channel_name}
    end
  end
  
  private
  def initOpenTok
    @api_key = "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d"
    if @@opentok.nil?
      @@opentok = OpenTok::OpenTokSDK.new 335312, @api_key
      @@opentok.api_url = 'https://staging.tokbox.com/hl'
    end
  end
  
end