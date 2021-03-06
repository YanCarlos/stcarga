module ApplicationHelper
  include MessagesHelper
  include LinksHelper

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

  def set_icon_helper text, icon
    icon = content_tag(:i, '', class: "fa fa-#{icon}")
    return "#{icon} #{text}".html_safe
  end


  def is_it_of_customer? import
    return true if (current_user.has_role?(:admin) || current_user.has_role?(:employee))
    import.user == current_user
  end

end
