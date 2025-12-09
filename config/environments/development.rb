Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.delivery_method = :smtp
  # ActionMailer Config
  config.action_mailer.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', 'smtp'),
    port: ENV.fetch('SMTP_PORT', '25').to_i,
    domain: ENV.fetch('SMTP_DOMAIN', 'wmap.cloud')
  }
  auth = ENV['SMTP_AUTHENTICATION'].to_s.downcase
  if auth.empty? || auth == 'none'
    # no auth: do not set :authentication, :user_name, :password
  else
    config.action_mailer.smtp_settings.merge!(
      authentication: auth.to_sym,
      user_name: ENV['SMTP_USER_NAME'],
      password: ENV['SMTP_PASSWORD']
    )
  end
  config.action_mailer.smtp_settings[:enable_starttls_auto] =
    ENV.fetch('SMTP_ENABLE_STARTTLS_AUTO', 'false') == 'true'
  config.action_mailer.smtp_settings[:tls] =
    ENV.fetch('SMTP_TLS', 'false') == 'true'

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  
  # Disable asset caching to avoid permission issues in Docker
  config.assets.cache_store = :null_store

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # debug CarrierWave upload
  CarrierWave.configure do |config|
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false
  end

end
