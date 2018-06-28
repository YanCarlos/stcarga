class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  binding.pry
  default from: ENV['EMAIL_USER']
end
