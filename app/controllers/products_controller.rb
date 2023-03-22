class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    if current_user.admin?
      @product = Product.new
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def create
    if current_user.admin?
      @product = Product.new(product_params)
      @product.user_id = current_user.id
      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
      else
        render :new
      end
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
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
    if current_user.admin?
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to products_path, notice: 'Product deleted successfully.'
    else
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :product_image)
  end
end
