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
      redirect_to @product, notice: 'Product was successfully created.'
    else
      redirect_to new_product_path, notice: 'Failed to create Product.'
    end
  end

  def show; end
  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    if Ad.find_by(product_id: @product.id)
      redirect_to stored_location, alert: 'Product is associated with ad, cannot be deleted!'
    else
      @product.destroy
      redirect_to stored_location, notice: 'Product deleted successfully.'
    end
  end

  def toggle_published
    # @product = Product.find(params[:id])
    @product.update_attribute(:status, !@product.status)
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
