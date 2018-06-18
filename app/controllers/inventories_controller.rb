class InventoriesController < ApplicationController
  before_action :set_container, only: [:update, :new]
  before_action :set_product, only: [:update, :new]
  before_action :set_import, only: [:update, :new, :create]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_inventory, only: [:destroy, :update, :edit]

  def new
    @container = Container.new
  end

  def edit
  end

  def create
    @inventory = ImportProduct.new(inventory_params)
    if @inventory.save
      success_message "Un producto llamado #{@inventory.product.name} fue agregado a la importación #{@inventory.import.code} del cliente #{@inventory.import.user.name}."
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
  def inventory_params
    params.require(:import_product).permit(
      :identification,
      :total_of_packages,
      :unit_by_package,
      :net_weight,
      :gross_weight,
      :import_id,
      :product_id,
      :container_id
    )
  end

  def set_inventory
    @inventory = ImportProduct.find(params[:id])
  end

  def set_container
    return if params[:container_id].nil?
    @container = Container.find(params[:container_id])
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
end
