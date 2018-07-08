class InventoriesController < ApplicationController
  before_action :set_container, only: [:update, :new]
  before_action :set_product, only: [:update, :new]
  before_action :set_import, only: [:update, :new, :create, :edit]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_inventory, only: [:destroy, :update, :edit]
  before_action :set_session_variable, only: [:edit, :destroy, :update, :create]
  before_action :is_repeated?, only: [:create]


  def new
  end

  def edit
    add_breadcrumb 'Importación', edit_import_path(@inventory.import)
  end


  def create
    if @inventory
      if @inventory.update_attributes(total_of_packages: (@inventory.total_of_packages + inventory_params[:total_of_packages].to_d))
        success_message "Al producto #{@inventory.product.name} de la importación #{@inventory.import.code} del cliente #{@inventory.import.user.name} se le agregaron #{inventory_params[:total_of_packages]} paquetes mas."
        redirect_to :back
      else
        render :new
      end
    else
      @inventory = ImportProduct.new(inventory_params)
      if @inventory.save
        success_message "Un producto llamado #{@inventory.product.name} fue agregado a la importación #{@inventory.import.code} del cliente #{@inventory.import.user.name}."
        redirect_to :back
      else
        render :new
      end
    end
  end

  def index
  end

  def update
    if @inventory.update(inventory_params)
      success_message "El inventario con producto #{@inventory.product.name} de la importacion #{@inventory.import.code} fue actualizado."
    else
      error_message "Error al actualizar inventario"
    end
    render :edit
  end

  def destroy
    if @inventory.destroy
      success_message "El inventario con producto #{@inventory.product.name} de la importacion #{@inventory.import.code} fue eliminado."
    else
      error_message "Error al eliminar inventario"
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

  def set_session_variable
    session[:last_stcarga_action] = :inventory
  end

  def is_repeated?
    @inventory = ImportProduct.where('import_id = ? and product_id = ? and container_id = ? and unit_by_package = ? and net_weight = ?', inventory_params[:import_id],  inventory_params[:product_id], inventory_params[:container_id], inventory_params[:unit_by_package].to_d, inventory_params[:net_weight].to_d)[0]
  end
end
