class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      # flash[:notice] = 'Failed to create Product.'
      redirect_to new_product_path, notice: 'Failed to create Product.'
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])

    @ads = Ad.all

    if Ad.find_by(product_id: @product.id)
      redirect_to products_path, alert: 'Product cannot be deleted!'
    else
      @product.destroy
      redirect_to products_path, notice: 'Product deleted successfully.'
    end
  end

  def toggle_status
    @product = Product.find(params[:id])
    @product.update_attribute(:status, !@product.status)
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :product_image)
  end
end
