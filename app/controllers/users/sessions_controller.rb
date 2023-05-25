class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_2fa!, only: %i[new create]
  before_action :authenticate_user!, except: %i[new create destroy]
  before_action :load_and_authorize_resource, except: %i[new create destroy]

  def new
    return if user_signed_in?

    super
  end

  def create
    if user_signed_in?
      redirect_to users_home_path
    else
      super
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:password, :otp_attempt, :email, :remember_me)
  end
end
