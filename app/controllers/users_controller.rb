class UsersController < ApplicationController

  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    @user.add_role params[:user][:roles]
    if @user.save
      redirect_to new_user_path
      success_message 'El usuario fue creado exitosamente!'
    else
      render :new
    end
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
end
