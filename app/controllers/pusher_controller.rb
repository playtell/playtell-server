class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action
  before_filter :authenticate_user!

  def auth
    response = nil;
    if params[:channel_name].split("-")[1] == "rendezvous" && !current_user.blank? #presence-rendezvous-channel
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
                  :user_id => current_user.id,
                  :user_info => {}
                  })
    else #elsif params[:channel_name].split("-")[1] == "playdate" #presence-playdate-channel-<playdateID>
      playdate = Playdate.find_by_id(params[:channel_name].split("-")[3])
      return render :text => "Playdate not found", :status => '100' if playdate.nil?
      if playdate.hasUser(current_user)
        session[:playdate] = playdate.id
        response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      end
    end

    if response  
      puts 'PUSHER: ' + current_user.displayName + '[' + current_user.id.to_s + '] subscribing to ' + params[:channel_name] 
      render :json => response 
    else
      render :text => "Not authorized", :status => '403'
    end
  end
end