class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    p = Playdate.find_by_id(params[:channel_name].split("-")[3])
    if p.hasUser(current_user)
      session[:playdate] = p.id
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      render :json => response
    else
      render :text => "Not authorized", :status => '403'
    end
  end
end