class Api::GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!

  respond_to :json
  
end