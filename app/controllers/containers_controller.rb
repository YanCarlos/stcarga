class ContainersController < ApplicationController
  before_action :set_customer, only: [:update, :new]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_container, only: [:destroy, :update, :edit]

  def new
    @container = Container.new
  end

  def edit
  end

  def create
    @container = Container.new(container_params)
    if @container.save
      success_message "El container fue agregado al cliente #{@container.user.name}."
    end
    redirect_to :back
  end

  def index
  end

  def update
    if @container.update(container_params)
      success_message "El container  #{@container.code} fue actualizado."
    else
      success_error "Error al actualizar container"
    end
    render :edit
  end

  def destroy
    if @container.destroy
      success_message "El container  #{@container.code} fue eliminado."
    else
      success_error "Error al eliminar container"
    end
    redirect_to containers_path
  end

  private
  def container_params
    params.require(:container).permit(
      :code,
      :deadline_to_return_at,
      :date_of_entry_to_warehose_at,
      :start_of_debt_at,
      :user_id
    )
  end

  def set_container
    @container = Container.find(params[:id])
  end

  def set_customer
    return if params[:user_id].nil?
    @customer = User.find(params[:user_id])
    unless @customer.has_role? :customer
      render 'errors/resource_is_not_the_role', locals: {resource: 'Cliente.' }
    end
  end

  def set_filter
    container_scope = Container.all.order(created_at: :desc)
    container_scope = container_scope.by_code(params[:filter]) if params[:filter]
    @containers = smart_listing_create(
      :containers,
      container_scope,
      partial: "containers/container_list",
      default_sort: {updated_at: 'desc'}
    )
  end
end
