if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              =>  'smtp.gmail.com',
    :port                 =>  587,
    :authentication       =>  :plain,
    :user_name            =>  'test77959',
    :password             =>  'test77959',
    :domain               =>  'gmail.com',
    :enable_starttls_auto  =>  true
  }
elsif Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              =>  'smtp.sendgrid.net',
    :port                 =>  '587',
    :authentication       =>  :plain,
    :user_name            =>  ENV['SENDGRID_USERNAME'],
    :password             =>  ENV['SENDGRID_PASSWORD'],
    :domain               =>  'heroku.com',
    :enable_starttls_auto  =>  true
  }
end
