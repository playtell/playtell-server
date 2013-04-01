class PasswordsController < Devise::PasswordsController
  layout 'devise'
    
  def new
    super
  end
  
  def create
    super
  end
  
  def edit
    super
  end
    
  # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(params[:user])

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message(:notice, flash_message) if is_navigational_format?
        #sign_in(resource_name, resource)
        respond_with resource
      else        
        puts resource.errors
        render :action => :edit
        
      end
    end

protected

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:error, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
        resource.respond_to?(:unlock_strategy_enabled?) &&
        resource.unlock_strategy_enabled?(:email)
    end
    
end