class AddressesController < ApplicationController
  load_and_authorize_resource

  def index
    @addresses = @addresses.paginate(page: params[:page], per_page: 5)
  end

  def new
    @address.user_id = current_user.id
  end

  def create
    @address.geocode
    @address.user_id = current_user.id

    if @address.save
      redirect_to addresses_path, notice: 'Address was successfully created.'
    else
      redirect_to new_address_path, notice: 'Address was not found'
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: 'Address was successfully updated'
    else
      redirect_to edit_address_path(@address), notice: 'Adddress was not updated'
    end
  end

  def destroy
    if Ad.find_by(address_id: @address.id)
      redirect_to addresses_path, alert: 'Address is associated with ad, cannot be deleted!'
    elsif @address.destroy
      redirect_to addresses_path, notice: 'Address deleted successfully.'
    else
      redirect_to addresses_path, notice: 'Failed to delete address.'
    end
  end

  private

  def address_params
    params.require(:address).permit(:user_id, :street1, :street2, :city, :state, :zip_code)
  end
end
