# frozen_string_literal: true

# Bids Controller
class BidsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource :ad, only: %i[new create]
  load_and_authorize_resource through: :ad, only: %i[new create]
  load_and_authorize_resource except: %i[new create]
  before_action :authenticate_user!

  def new; end

  def create
    @bid.user_id = current_user.id

    if @bid.save
      respond_to do |format|
        flash[:notice] = 'Bid was created successfully.'
        ActionCable.server.broadcast('bids_channel',
                                     { ad_id: @bid.ad_id,
                                       price: number_to_currency(@bid.price, unit: 'Rs', format: '%u. %n'),
                                       buyer_name: @bid.user.full_name })
        format.json { render :show, status: :created, location: @bid }
        format.html { redirect_to stored_location }
      end
    else
      flash[:alert] = @bid.errors.full_messages.join(', ')
      render :new
    end
  end

  def index
    @bids = @bids.includes([ad: :product]).recently_updated.page(params[:page])
  end

  private

  def bid_params
    params.require(:bid).permit(:ad_id, :price)
  end
end
