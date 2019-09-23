source 'https://rubygems.org'
#ruby "2.5.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Basic gems for Rails 5.2
gem 'rails', '~> 5.2.2.1'
# Support .env file  loadinging
gem 'dotenv-rails',groups: [:development, :test, :production]
# Use puma applicaton server
gem 'puma', '~> 3.7'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Excel spreadsheet support
gem 'rubyXL', '=3.3.33'
# file upload
gem 'carrierwave', '~> 0.10.0'
# report upload
gem 'sequel'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end
group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
################################################################################

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby
#gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

################################################################################
# www_wmap related gem
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'bootstrap'
gem 'bootstrap_form'
gem 'will_paginate'
gem 'wmap', '>=2.5.9'
# logon form input validations
gem 'client_side_validations'
##  Support  LDAP authentication
gem 'devise'
gem "devise_ldap_authenticatable"
gem 'server-generated-popups'
gem 'responders'
gem 'netaddr'
gem 'parallel'
gem 'whois'
gem 'httpclient'
gem 'net-ping'
gem 'open_uri_redirections'
gem 'dnsruby'
gem 'geoip'
gem 'sidekiq' #move discovery job to background
gem 'sidekiq-batch'
#gem 'sidekiq-status'
gem 'sinatra', '= 2.0.4' #require for sidekiq web
###############################################################################



#source 'https://rails-assets.org' do
#  gem 'rails-assets-tether', '>= 1.1.0'
#end
