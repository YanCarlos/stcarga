module MessagesHelper
  def success_message msg
    flash[:success] = msg
  end

  def error_message msg
    flash[:error] = msg
  end

  def warning_message msg
    flash[:warning] = msg
  end

  def custom_notification_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
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

