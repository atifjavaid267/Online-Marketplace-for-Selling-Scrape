class OtpController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
  end
end
