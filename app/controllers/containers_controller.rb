class ContainersController < ApplicationController
  before_action :set_customer, only: [:create, :update]

  def new
    @container = Container.new
  end

  def create
  end

  def update
  end

  private
  def container_params
    params.permit(:container).require(
      :code,
      :deadline_to_return_at,
      :date_of_entry_to_warehose_at,
      :start_of_debt_at
    )
  end

  def set_container
    @container = Container.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:user_id])
  end
end
