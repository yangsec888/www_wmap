ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              =>  'smtp.sendgrid.net',
  :port                 =>  '587',
  :authentication       =>  :plain,
  :user_name            =>  'app86068046@heroku.com',
  :password             =>  'ousz8vlp2061',
  :domain               =>  'heroku.com',
  :enable_starttls_auto  =>  true
}
