class AddressesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @addresses = @addresses.paginate(page: params[:page], per_page: 6)
  end

  def new
    @address.user_id = current_user.id
  end

  def create
    @address.geocode

    @address.user_id = current_user.id

    if @address.save
      flash[:notice] = 'Address was successfully created.'
      redirect_to addresses_path
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
      redirect_to new_address_path
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      flash[:notice] = 'Address was successfully updated'
      redirect_to addresses_path
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:notice] = 'Address deleted successfully.'
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
    end
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:user_id, :street1, :street2, :city, :state, :zip_code)
  end
end
