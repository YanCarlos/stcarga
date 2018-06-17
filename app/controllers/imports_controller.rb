class ImportsController < ApplicationController
  before_action :set_filter, only: [:index]
  before_action :set_import, only: [:update, :destroy, :edit]

  def new
    @import = Import.new
  end

  def edit
  end

  def index
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
      success_error "Error al intentar eliminar una importación."
    end
    redirect_to :back
  end

  def update
    if @import.update(import_params)
      success_message "La importación #{@import.code} fue actualizada."
      redirect_to edit_import_path(@import)
    else
      success_error "Hubo un error al editar la importación"
      render :edit
    end

  end


  private
  def import_params
    params.require(:import).permit(:code, :date, :user_id)
  end

  def set_filter
    import_scope = Import.all
    import_scope = import_scope.by_code(params[:filter]) if params[:filter]
    @imports = smart_listing_create(
      :imports,
      import_scope,
      partial: 'imports/imports_list',
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
