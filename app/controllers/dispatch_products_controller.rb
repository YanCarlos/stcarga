class DispatchProductsController < ApplicationController
  before_action :set_dispatch, only: [:create, :new, :update, :destroy, :edit, :index]
  before_action :set_filter, only: [:index]
  before_action :set_dispatch_product, only: [:edit, :new, :destroy, :update]

  def new
  end

  def show
    add_breadcrumb 'Despacho', edit_dispatch_path(@dispatch_product.dispatch)
  end

  def edit
    add_breadcrumb 'Despacho', edit_dispatch_path(@dispatch_product.dispatch)
  end

  def create
    @dispatch_product = DispatchProduct.where('dispatch_id = ? and import_product_id = ?', dispatch_products_params[:dispatch_id],  dispatch_products_params[:import_product_id] )[0]
    if @dispatch_product
      if @dispatch_product.update_attributes(total_of_packages: (@dispatch_product.total_of_packages + dispatch_products_params[:total_of_packages].to_d))
        success_message "Al producto #{@dispatch_product.import_product.product.name} del despacho #{@dispatch_product.dispatch.code} del cliente #{@dispatch_product.dispatch.import.user.name} se le agregaron #{dispatch_products_params[:total_of_packages]} paquetes mas."
        redirect_to :back
      else
        render :new
      end
    else
      @dispatch_product = DispatchProduct.new(dispatch_products_params)
      if @dispatch_product.save
        success_message "Un producto llamado #{@dispatch_product.import_product.product.name} fue agregado al despacho #{@dispatch_product.dispatch.code} del cliente #{@dispatch_product.dispatch.import.user.name}."
        redirect_to :back
      else
        render :new
      end
    end
  end

  def index
  end

  def update
    avaliable = products_in_stock(dispatch_products_params[:import_product_id]).to_d + @dispatch_product.total_of_packages.to_d
    if  avaliable  >= dispatch_products_params[:total_of_packages].to_d
      if @dispatch_product.update(dispatch_products_params)
        success_message "El producto #{@dispatch_product.import_product.product.name} del despacho #{@dispatch_product.dispatch.code} fue actualizado."
        redirect_to edit_dispatch_path(@dispatch_product.dispatch)
      else
        error_message "Error al actualizar el producto"
        render :edit
      end
    else
      error_message "La maxima cantidad a asignar en la actualización de este producto es: #{avaliable}"
      render :edit
    end
    
  end

  def destroy
    if @dispatch_product.destroy
      success_message "El producto #{@dispatch_product.import_product.product.name} del despacho #{@dispatch_product.dispatch.code} fue actualizado fue eliminado."
    else
      error_message "Error al eliminar producto"
    end
    redirect_to :back
  end

  def get_products_in_stock
    result = products_in_stock params[:import_product_id]
    render json: result
  end

  private

  def dispatch_products_params
    params.require(:dispatch_product).permit(
      :dispatch_id,
      :import_product_id,
      :total_of_packages
    )
  end

  def set_dispatch_product
    @dispatch_product = DispatchProduct.find(params[:id])
  end

  def set_dispatch
    return if params[:dispatch_id].nil?
    @dispatch = Dispatch.find(params[:dispatch_id])
  end

  def set_import
    return if params[:import_id].nil?
    @import = Import.find(params[:import_id])
  end

  def set_product
    return if params[:product_id].nil?
    @import = Import.find(params[:product_id])
  end

  def set_filter
    product_scope = DispatchProduct.all
    product_scope = product_scope.filter(params[:filter]) if params[:filter].present?
    @dispatch_products = smart_listing_create(
      :dispatch_products,
      product_scope,
      partial: "dispatch_products/products_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_session_variable
    session[:last_stcarga_action] = :inventory
  end

  def products_in_stock import_product_id
    registered_in_import = ImportProduct.where('id = ?', import_product_id).sum(:total_of_packages)
    registered_in_dispatchs = DispatchProduct.where('import_product_id = ?', import_product_id).sum(:total_of_packages)
    return registered_in_import - registered_in_dispatchs
  end
end
