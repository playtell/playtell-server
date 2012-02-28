class SessionsController < Devise::SessionsController
  
  def new
    puts "in sessions controller: " + session[:user_return_to] if session[:user_return_to]
    super
  end
  
  def create
    super
  end
  
end