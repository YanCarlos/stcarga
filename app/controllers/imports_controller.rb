class ImportsController < ApplicationController
  before_action :set_filter, only: [:index]
  before_action :set_import, only: [:update, :destroy, :edit]
  before_action :set_filter_for_inventories, only: [:edit]
  before_action :set_filter_for_dispatches, only: [:edit]


  def new
    @import = Import.new
    add_breadcrumb 'Importaciones', :imports_path
  end

  def edit
    render 'errors/record_not_found' unless is_it_of_customer?(@import)
  end

  def index
  end

  def show
    render 'errors/record_not_found'
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      success_message "La importación con codigo #{@import.code} fue guardada."
      redirect_to :back
    else
      render :new
    end
  end

  def destroy
    if @import.destroy
      success_message "La importación #{@import.code} fue eliminada."
    else
      error_message "Error al intentar eliminar una importación."
    end
    redirect_to :back
  end

  def update
    if @import.update(import_params)
      success_message "La importación #{@import.code} fue actualizada."
      redirect_to edit_import_path(@import)
    else
      error_message "Hubo un error al editar la importación"
      render :edit
    end

  end


  private
  def import_params
    params.require(:import).permit(:code, :date, :user_id, :importer, :description, :warehose_origin)
  end

  def set_filter
    if current_user.has_role? :customer
      import_scope = current_user.imports.all
      import_scope = import_scope.by_code(params[:filter]) if params[:filter]
    else
      import_scope = Import.all
      import_scope = import_scope.by_code(params[:filter]) if params[:filter]
    end
    @imports = smart_listing_create(
      :imports,
      import_scope,
      partial: 'imports/imports_list',
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_filter_for_inventories
    inventories_scope = ImportProduct.all
    inventories_scope = inventories_scope.by_import(params[:id]) if params[:id]
    inventories_scope = inventories_scope.filter(params[:filter]) if params[:filter].present?
    @inventories = smart_listing_create(
      :inventories,
      inventories_scope,
      partial: "inventories/inventories_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_filter_for_dispatches
    dispatches_scope = Dispatch.all
    dispatches_scope = dispatches_scope.by_import(params[:id]) if params[:id]
    dispatches_scope = dispatches_scope.filter(params[:filter]) if params[:filter].present?
    @dispatches = smart_listing_create(
      :dispatches,
      dispatches_scope,
      partial: "dispatches/dispatches_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
