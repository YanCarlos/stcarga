module ApplicationHelper
  def is_active_controller(controller_name, class_name = nil)
      if params[:controller] == controller_name
       class_name == nil ? "active" : class_name
      else
         nil
      end
  end

  def is_active_action(action_name)
      params[:action] == action_name ? "active" : nil
  end

  def flash_class(level)
    case level
      when 'info' then "alert alert-info"
      when 'notice','success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end
end
