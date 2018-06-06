class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_filter, only: [:index, :destroy]
  before_action :set_filter_for_containers, only: [:show]

  def index; end

  def new
    @user = User.new
  end

  def show; end

  def edit; end

  def create
    @user = User.new(user_params)
    set_role
    if @user.save
      redirect_to new_user_path
      success_message 'El usuario fue creado exitosamente!'
    else
      render :new
    end
  end

  def update
    set_role
    if @user.update(user_params)
      redirect_to edit_user_path(@user)
      success_message 'El usuario fue modificado correctamente!'
    else
      render :edit
    end
  end

  def destroy
    if current_user.has_role? :admin
      if @user.destroy
        success_message "El usuario #{@user.name} fue eliminado."
      end
    else
      success_message 'Solo un administrador puede eliminar un usuario.'
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :phone,
      :address,
      :active,
      :contact_name,
      :contact_email,
      :contact_phone,
      :identification
    )

  end

  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render 'errors/record_not_found'
    end
  end

  def set_filter
    users_scope = User.all
    users_scope = User.by_name(params[:filter]) if params[:filter]
    @users = smart_listing_create(
      :users,
      users_scope,
      partial: "users/tabs",
      default_sort: {name: "asc"}
    )
  end

  def set_role
    @user.roles = []
    @user.add_role params[:user][:roles]
  end


  def set_filter_for_containers
    container_scope = Container.all
    container_scope = container_scope.by_customer(params[:id]) if params[:id]
    container_scope = container_scope.by_code(params[:filter]) if params[:filter]
    @containers = smart_listing_create(
      :containers,
      container_scope,
      partial: "containers/container_list",
      default_sort: {updated_at: 'asc'}
    )
  end
end
