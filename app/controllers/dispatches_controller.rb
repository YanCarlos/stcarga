class DispatchesController < ApplicationController
  before_action :set_import, only: [:update, :new, :create, :edit]
  before_action :set_dispatch, only: [:destroy, :update, :edit, :dispatch_print]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_filter_for_dispatch_product, only: [:edit, :update]
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
      error_message 'Error al actualizar despacho'
    end
    redirect_to :back
  end

  def destroy
    if @dispatch.destroy
      success_message "El despacho con codigo #{@dispatch.code} de la importacion #{@dispatch.import.code} fue eliminado."
    else
      error_message 'Error al eliminar despacho'
    end
    redirect_to :back
  end

  def dispatch_print
    respond_to  do |format|
      format.html
       format.pdf do
         render pdf: "Despacho con codigo: #{@dispatch.code}",
         template: "dispatches/dispatch_print.html.haml",
         layout: 'pdf/main.html.haml',
         :margin => {:bottom => 20},
         footer: {html: {template: 'layouts/pdf/footer.html.haml'}},
         show_as_html: params.key?('debug')
        end
     end
  end

  private
  def dispatch_params
    params.require(:dispatch).permit(
      :date,
      :phone_number_1,
      :import_id,
      :description,
      :city,
      :address,
      :driver_id
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

  def set_filter_for_dispatch_product
    product_scope =  DispatchProduct.by_dispatch(@dispatch.id)
    product_scope = product_scope.filter(@dispatch, params[:filter]) if params[:filter].present?
    @dispatch_products = smart_listing_create(
      :dispatch_products,
      product_scope,
      partial: "dispatch_products/products_list",
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_session_variable
    session[:last_stcarga_action] = :dispatch
  end
end
