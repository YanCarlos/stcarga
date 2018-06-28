class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: ENV['EMAIL_USER']
end
