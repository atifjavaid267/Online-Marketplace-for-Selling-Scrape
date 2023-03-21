class ProductsController < ApplicationController
  has_one_attached :image

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
      @product.image.attach(params[:product][:image])
      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
      else
        render :new
      end
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def delete_product
    if current_user.admin?
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to root_path, notice: 'Product deleted successfully.'
    else
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:user_id, :name, :description)
  end
end
