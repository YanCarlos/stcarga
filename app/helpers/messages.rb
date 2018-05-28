module Messages
  def success_message msg
    flash[:success] = msg
  end

  def error_message msg
    flash[:error] = msg
  end
end

