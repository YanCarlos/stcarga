class ContainersController < ApplicationController
  before_action :set_customer, only: [:update, :new]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_container, only: [:destroy, :update]

  def new
    @container = Container.new
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
  end

  def destroy
    @container.destroy
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
    @customer = User.find(params[:user_id])
    unless @customer.has_role? :customer
      render 'errors/resource_is_not_the_role', locals: {resource: 'Cliente.' }
    end
  end

  def set_filter
    binding.pry
    container_scope = Container.all
    container_scope = Container.by_customer(params[:id]) if params[:id]
    container_scope = Container.by_code(params[:filter]) if params[:filter]
    @containers = smart_listing_create(
      :containers,
      container_scope,
      partial: "containers/container_list",
      default_sort: {updated_at: 'asc'}
    )
  end
end
