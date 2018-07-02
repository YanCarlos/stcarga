class DispatchProductsController < ApplicationController
  before_action :set_dispatch, only: [:create, :new, :update, :destroy, :edit]

  def new
  end

  def edit
  end

  def create
    @dispatch_product = DispatchProduct.new(dispatch_products_params)
    if @dispatch_product.save
      success_message "Un producto llamado #{@dispatch_product.import_product.product.name} fue agregado al despacho #{@dispatch_product.dispatch.code} del cliente #{@dispatch_product.dispatch.import.user.name}."
      redirect_to :back
    else
      render :new
    end
  end

  def index
  end

  def update
    if @inventory.update(inventory_params)
      success_message "El inventario con producto #{@inventory.product.name} de la importacion #{@inventory.import.code} fue actualizado."
    else
      success_error "Error al actualizar inventario"
    end
    render :edit
  end

  def destroy
    if @inventory.destroy
      success_message "El inventario con producto #{@inventory.product.name} de la importacion #{@inventory.import.code} fue eliminado."
    else
      success_error "Error al eliminar inventario"
    end
    redirect_to :back
  end

  private
  def dispatch_products_params
    params.require(:import_product).permit(
      :dispatch_id,
      :import_product_id,
      :total_of_packages
    )
  end

  def set_inventory
    @inventory = ImportProduct.find(params[:id])
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
    inventories_scope = ImportProduct.all
    inventories_scope = inventories_scope.filter(params[:filter]) if params[:filter].present?
    @inventories = smart_listing_create(
      :inventories,
      inventories_scope,
      partial: "inventories/inventories_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_session_variable
    session[:last_stcarga_action] = :inventory
  end
end
