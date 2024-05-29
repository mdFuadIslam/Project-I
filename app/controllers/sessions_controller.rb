class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    # Add this conditional statement to check if the user's status is 'blocked'
    if resource.status == "blocked"
      set_flash_message!(:alert, :blocked)
      sign_out(resource_name) # Add this line to sign out the user
      redirect_to new_user_session_path # Add this line to redirect to the login page
    else
      set_flash_message!(:notice, :signed_in) if is_navigational_format? # Move this line inside the else block
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end
