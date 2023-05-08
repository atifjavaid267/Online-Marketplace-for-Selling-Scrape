class AddressesController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @addresses = current_user.addresses.paginate(page: params[:page], per_page: 5)
  end

  def new
    @address = Address.new
    @address.user_id = current_user.id
  end

  def create
    @address = current_user.addresses.build(address_params)
    @address.geocode
    # byebug
    # @address.zip_code = Geocoder.search(@address.geocode).first.postal_code
    if @address.latitude.zero? || @address.longitude.zero?
      redirect_to new_address_path, notice: 'Address was not found' and return
    else
      @address.save
      redirect_to addresses_path, notice: 'Address was successfully created.'
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
      redirect_to addresses_path, notice: 'Address was successfully updated'
    else
      redirect_to edit_address_path, notice: 'address was not updated'
    end
  end

  def destroy
    @address = Address.find(params[:id])

    if Ad.find_by(address_id: @address.id)
      redirect_to addresses_path, alert: 'Address cannot be deleted!'
    else
      @address.destroy
      redirect_to addresses_path, notice: 'Address deleted successfully.'
    end
  end

  private

  def address_params
    params.require(:address).permit(:user_id, :street1, :street2, :city, :state, :zip_code)
  end
end
