# frozen_string_literal: true

# Address Controller
class AddressesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :store_location, only: %i[index]

  def index
    @addresses = @addresses.paginate(page: params[:page], per_page: RECORDS_PER_PAGE)
  end

  def new
    @address.user_id = current_user.id
  end

  def create
    if @address.save
      flash[:notice] = 'Address was successfully created.'
      redirect_to stored_location
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
      render :new
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
