class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    unless params[:feedback][:rating].blank? and params[:feedback][:comment].blank?
      @feedback = Feedback.new(params[:feedback])
      @feedback.save
    end
    respond_to do |format|
      format.js 
    end
  end

end
