class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.save
      respond_to do |format|
        format.js 
        format.html { redirect_to disconnect_playdate_path }
      end
    end
  end

end
