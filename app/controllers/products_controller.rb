class ProductsController < ApplicationController
  before_action :set_filter, only: [:index]
  before_action :set_product, only: [:update, :destroy, :edit]

  def new
    @product = Product.new
  end

  def edit
  end

  def index
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      success_message "El producto con nombre #{@product.name} fue guardado."
      redirect_to new_product_path
    else
      render :new
    end
  end

  def destroy
    if @product.destroy
      success_message "El producto #{@product.name} con referencia #{@product.reference} fue eliminado."
    else
      success_error "Error al intentar eliminar un producto."
    end
    redirect_to products_path
  end

  def update
    if @product.update(product_params)
      success_message "El producto #{@product.name} con referencia #{@product.reference} fue actualizado."
      redirect_to edit_product_path(@product)
    else
      success_error "Hubo un error al editar el producto"
      render :edit
    end

  end


  private
  def product_params
    params.require(:product).permit(:name, :reference, :description)
  end

  def set_filter
    product_scope = Product.all#.order(created_at: :desc)
    product_scope = product_scope.by_name(params[:filter]) if params[:filter]
    @products = smart_listing_create(
      :products,
      product_scope,
      partial: 'products/product_list',
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
