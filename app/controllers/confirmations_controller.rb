# coding: utf-8
class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      if Devise.allow_insecure_sign_in_after_confirmation
        set_flash_message(:notice, :confirmed_and_signed_in) if is_navigational_format?
        sign_in(resource_name, resource)
      else
        set_flash_message(:notice, :confirmed) if is_navigational_format?
      end
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

  protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(resource_name)
      new_session_path(resource_name) if is_navigational_format?
    end

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      if Devise.allow_insecure_sign_in_after_confirmation
        after_sign_in_path_for(resource)
      elsif signed_in?
        signed_in_root_path(resource)
      else
        new_session_path(resource_name)
      end
    end
end
