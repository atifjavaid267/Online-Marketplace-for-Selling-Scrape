class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[show_root]
  load_and_authorize_resource

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @products = Product.all.where(status: true).paginate(page: params[:page], per_page: 6)
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
      redirect_to new_product_path, notice: 'Failed to create Product.'
    end
  end

  def show; end

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
      flag = @product.status
      @product.destroy
      if flag
        redirect_to products_path, notice: 'Product deleted successfully.'
      else
        redirect_to archives_products_path, notice: 'Product deleted successfully.'
      end
    end
  end

  def publish
    @product = Product.find(params[:id])
    @product.update_attribute(:status, !@product.status)
    redirect_to archives_products_path
  end

  def unpublish
    @product = Product.find(params[:id])
    @product.update_attribute(:status, !@product.status)
    redirect_to products_path
  end

  def archives
    @archive_products = Product.where(status: false).paginate(page: params[:page], per_page: 5)
  end

  def show_root
    @products = Product.all.where(status: true).paginate(page: params[:page], per_page: 4)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :product_image)
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
