class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include Messages

  protected
  def after_sign_in_path_for(resource)
    if current_user.active?
      panel_root_path
    else
      inactive_user_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
