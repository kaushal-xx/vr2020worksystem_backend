class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:smtp, :from_email)
  layout 'mailer'
end
