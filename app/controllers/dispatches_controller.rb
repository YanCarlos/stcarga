class DispatchesController < ApplicationController
  before_action :set_import, only: [:update, :new, :create, :edit]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_dispatch, only: [:destroy, :update, :edit]
  before_action :set_session_variable, only: [:edit, :destroy, :update, :create]


  def new
  end

  def edit
    add_breadcrumb 'Importación', edit_import_path(@dispatch.import)
  end

  def create
    @dispatch = Dispatch.new(dispatch_params)
    if @dispatch.save
      success_message "Un despacho con codigo #{@dispatch.code} fue agregado a la importación #{@dispatch.import.code} del cliente #{@dispatch.import.user.name}."
      redirect_to :back
    else
      render :new
    end
  end

  def index
  end

  def update
    add_breadcrumb 'Importación', edit_import_path(@dispatch.import)
    if @dispatch.update(dispatch_params)
      success_message "El despacho con codigo #{@dispatch.code} de la importacion #{@dispatch.import.code} fue actualizado."
    else
      success_error 'Error al actualizar despacho'
    end
    render :edit
  end

  def destroy
    if @dispatch.destroy
      success_message "El despacho con codigo #{@dispatch.code} de la importacion #{@dispatch.import.code} fue eliminado."
    else
      success_error 'Error al eliminar despacho'
    end
    redirect_to :back
  end

  private
  def dispatch_params
    params.require(:dispatch).permit(
      :code,
      :date,
      :contact,
      :phone_number_1,
      :phone_number_2,
      :import_id,
      :description,
      :city,
      :address
    )
  end

  def set_dispatch
    @dispatch = Dispatch.find(params[:id])
  end


  def set_import
    return if params[:import_id].nil?
    @import = Import.find(params[:import_id])
  end

  def set_filter
    dispatch_scope = ImportProduct.all
    dispatch_scope = inventories_scope.filter(params[:filter]) if params[:filter].present?
    @inventories = smart_listing_create(
      :dispatches,
      dispatch_scope,
      partial: "dispatches/dispatches_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_session_variable
    session[:last_stcarga_action] = :dispatch
  end
end
