class ApplicationMailer < ActionMailer::Base
  default from: 'deploy@wmap.io'
  layout 'mailer'
end
