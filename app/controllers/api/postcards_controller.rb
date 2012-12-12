class Api::PostcardsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json

  # photo will come in with sender_id, receiver_id, photo 
  def create
    receiver_id = params[:receiver_id]
    sender_id = params[:sender_id] 
    photo = params[:photo]

    puts request.format
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if receiver_id.nil? or sender_id.nil? or photo.blank? 
      render :status=>400, :json=>{:message=>"The request must contain the receiver_id, sender_id, and photo."}
      return
    end
    
    r = User.find(receiver_id)
    s = User.find(sender_id)
    if r.nil? or s.nil?
      render :status=>401, :json=>{:message=>"Sender or receiver doesn't exist with that ID."}
      return
    end

    @postcard = Postcard.new(:receiver_id => receiver_id, :sender_id => sender_id, :sender_name => s.displayName)
    @postcard.photo = photo

    if @postcard.save
      render :status=>200, :json=>{:postcard=>@postcard}
    else
      puts @postcard.errors.inspect
      render :status=>400, :json=>{:message=>"Error saving photo"}
    end

  end
    
  # given a user_id, return a count of unviewed photos
  def num_new_photos

    user_id = params[:user_id]

  #    if request.format != :json
  #        render :status=>406, :json=>{:message=>"The request must be json"}
  #        return
  #    end

    if user_id.nil?
      render :status=>400, :json=>{:message=>"The request must contain a user_id."}
      return
    end

    count = Postcard.where("receiver_id = ? AND viewed = ?", user_id, false).count    
    render :status=>200, :json => {:num_new_photos => count}

  end
  
  # given a user_id, return all postcards 
  def all_photos
    
    user_id = params[:user_id]

    if user_id.nil?
      render :status=>400, :json=>{:message=>"The request must contain the user_id."}
      return
    end

    u = User.find(user_id)
    if u.nil?
      logger.info("User with email #{email} failed signin: user cannot be found.")
      render :status=>401, :json=>{:message=>"User cannot be found."}
      return
    end
    
    render :status=>200, :json => u.postcards.order('created_at desc')
    u.postcards.where("viewed = ?", false).each do |p|
      p.viewed = true
      p.save
    end
  end

end
