class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: %i[show_root]
  before_action :store_location, only: %i[index archives]

  def index
    @products = @products.published.paginate(page: params[:page], per_page: 6)
  end

  def new; end

  def create
    @product.user_id = current_user.id

    if @product.save
      flash[:notice] = 'Product created successfully.'
      redirect_to @product
    else
      flash[:alert] = 'Failed to create a Product.'
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
      flash[:alert] = 'Failed to update the Product.'
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = 'Product deleted successfully.'
    else
      flash[:alert] = @product.errors.full_messages[0]
    end
    redirect_to stored_location
  end

  def toggle_status
    @product.update_attribute(:status, !@product.status)
    flash[:notice] = @product.status == true ? 'Product Published' : 'Product Unpublished'
    redirect_to stored_location
  end

  def archives
    @archive_products = @products.unpublished.paginate(page: params[:page], per_page: 6)
  end

  def show_root
    @products = Product.published.paginate(page: params[:page], per_page: 4)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :product_image)
  end
end
