# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        sign_in(resource)
        redirect_to users_home_path
      else
        set_flash_message!(:alert, :confirmation_error)
      end
    end
  end
end
