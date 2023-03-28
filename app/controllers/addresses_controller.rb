class AddressesController < ApplicationController

  def index
    @addresses = current_user.addresses
  end

  def new
    if current_user.seller?
      @address = Address.new
      # @address.user_id = current_user.id
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def create
    if current_user.seller?
      @address = current_user.addresses.build(address_params)
      # @address.user_id = current_user.id
      # byebug
      if @address.save

        redirect_to addresses_path, notice: "Address was successfully created."
      else
        render :new
      end
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def edit
    @address = Address.find(params[:id])
    @address.user_id = current_user.id
  end

  def update
    @address = Address.find(params[:id])
    @address.user_id = current_user.id

    if @address.update(address_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    if current_user.seller?
      @address = Address.find(params[:id])
      @address.destroy
      redirect_to addresses_path, notice: 'Address deleted successfully.'
    else
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  private

  def address_params
    params.require(:address).permit(:user_id, :street1, :street2, :city, :state, :zip_code, :latitude, :longitude)
  end
end
