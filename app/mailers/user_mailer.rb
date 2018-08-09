class UserMailer < ApplicationMailer

  def customer_registered user, token
    @user = user
    @token = token
    mail(to: @user.email, bcc: [@user.email, ENV['BCC_EMAIL']], subject: 'Bienvenido a nuestra compañia.')
  end

  def employee_registered user, token
    @user = user
    @token = token
    mail(to: @user.email, bcc: [ENV['BCC_EMAIL']], subject: 'Bienvenido a nuestra compañia.')
  end

end
