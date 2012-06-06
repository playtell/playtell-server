class Api::PusherController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
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
      render :status=>200, :json=>{ :message => 'Turn page sent via pusher on ' + @playdate.pusher_channel_name } 
    end
  end
  
  # required params: playdate_id, book_id, page_num
  def change_book
    @playdate = Playdate.find(params[:playdate_id])
    if !@playdate or @playdate.blank?
      render :status=>100, :json=>{ :message => "Playdate not found." }
      return
    elsif @playdate.disconnected?
      render :status=>101, :json=>{ :message=> "Playdate has ended." }
      return
    else
      @playdate.change = Playdate::CHANGE_BOOK
      @playdate.save
      if !changeBook
        render :status=>120, :json=>{ :message=> "Book not found." }
        return
      end
      render :status=>200, :json=>{:message => 'Change book sent via pusher on '+ @playdate.pusher_channel_name }           
    end
  end
  
  # required params: book_id
  def close_book
    render :status=>200, :json=>{:message => 'close_book called'}
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
    render :status=>200, :json=>{:message => 'End playdate sent via pusher on '+ @playdate.pusher_channel_name}
  end
  
end