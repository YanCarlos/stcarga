class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include ApplicationHelper
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  before_filter :set_current_user
  before_filter :validate_user

  def set_current_user
    User.current = current_user
  end

  def validate_user
    return  if controller_name.to_sym == :sessions
    if current_user.has_role? :customer
      unless controller_name.to_sym == :imports ||  controller_name.to_sym == :dispatches
        redirect_to imports_path
      end 
    end
  end

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

  def route_name
    Rails.application.routes.router.recognize(request) do |route, _|
      return route.name.to_sym
    end
  end
end
