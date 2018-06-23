class DriversController < ApplicationController
  before_action :set_filter, only: [:index]
  before_action :set_driver, only: [:update, :destroy, :edit]
  add_breadcrumb 'Inicio', :panel_root_path

  def new
    @driver = Driver.new
  end

  def edit
  end

  def index
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      success_message "El conductor con nombre #{@driver.name} fue guardado."
      redirect_to new_driver_path
    else
      render :new
    end
  end

  def destroy
    if @driver.destroy
      success_message "El conductor #{@driver.name} fue eliminado."
    else
      success_error "Error al intentar eliminar un conductor."
    end
    redirect_to drivers_path
  end

  def update
    if @driver.update(driver_params)
      success_message "El conductor #{@driver.name} fue actualizado."
      redirect_to edit_driver_path(@driver)
    else
      success_error "Hubo un error al editar el conductor"
      render :edit
    end

  end


  private
  def driver_params
    params.require(:driver).permit(
      :name,
      :identification,
      :description,
      :phone,
      :carriage_plate,
      :trailer
    )
  end

  def set_filter
    driver_scope = Driver.all.order(created_at: :desc)
    driver_scope = driver_scope.filter(params[:filter]) if params[:filter]
    @driver = smart_listing_create(
      :drivers,
      driver_scope,
      partial: 'drivers/drivers_list',
      default_sort: {updated_at: 'desc'}
    )
  end

  def set_driver
    begin
      @driver = Driver.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render 'errors/record_not_found'
    end
  end
end
