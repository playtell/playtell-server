class Api::PusherController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  # requires params playdate_id, activity_id, new_page_num
  def turn_page
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{:message => "Playdate not found."}
      return
    elsif p.disconnected?
      render :status=>101, :json=>{:message=>"Playdate has ended."}
      return
    else
      @playdate.change = Playdate::TURN_PAGE
      @playdate.save
      turnPage
      render :status=>200, :json=>{:message => 'Turn page sent via pusher'} 
    end
  end

end