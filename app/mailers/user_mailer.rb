class UserMailer < ApplicationMailer
  default :from => ENV['EMAIL_USER']


  def customer_registered user
    @user = user
    mail(to: @user.contact_email, :bcc => [@user.email, ENV['BCC_EMAIL']], subject: 'Bienvenido a nuestra compañia.')
  end

  def employee_registered user
    @employee = user
    mail(to: @employee.email, subject: 'Bienvenido a nuestra compañia.')
  end

end
