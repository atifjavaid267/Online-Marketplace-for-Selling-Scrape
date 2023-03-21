class OtpController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    #   if params[:session].present?
    #     user = User.find_by(email: params[:session][:email])
    #     otp = params[:session][:otp_code]
    #     if user.authenticate_otp(otp)
    #       session[:user_id] = user.id
    #       flash[:success] = 'Successfully logged in'
    #       redirect_to "otp_create_path"
    #     else
    #       flash.now[:danger] = 'Something wrong with your login information!'
    #     end
    #   else
    #     flash.now[:danger] = 'Session parameters not found!'
    #   end
    # end
  end
end
