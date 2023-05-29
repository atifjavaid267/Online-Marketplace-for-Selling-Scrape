# frozen_string_literal: true

# Product Controller
class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :store_location, only: %i[index]

  def index
    @products = @products.status(params[:status] || true).order(updated_at: :desc).paginate(page: params[:page],
                                                                                            per_page: RECORDS_PER_PAGE)
    @products = @products.includes([product_image_attachment: :blob])
  end

  def new; end

  def create
    @product.user_id = current_user.id

    if @product.save
      flash[:notice] = 'Product created successfully.'
      redirect_to @product
    else
      flash[:alert] = @product.errors.full_messages.join(', ')
      render :new
    end
  end

  def show; end
  def edit; end

  def update
    if @product.update(product_params)
      flash[:notice] = 'Product updated successfully.'
      redirect_to @product
    else
      flash[:alert] = @product.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = 'Product deleted successfully.'
    else
      flash[:alert] = @product.errors.full_messages.join(', ')
    end
    redirect_to stored_location
  end

  def toggle_status
    if @product.update_attribute(:status, !@product.status)
      flash[:notice] = @product.status == true ? 'Product Published' : 'Product Unpublished'
    else
      flash[:alert] = @product.errors.full_messages.join(', ')
    end
    redirect_to products_path(status: true)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :product_image)
  end
end
