require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WmapPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Logger adjustment for Docker
    #logger           = ActiveSupport::Logger.new(STDOUT)
    #logger.formatter = config.log_formatter
    #config.log_tags  = [:subdomain, :uuid]
    #config.logger    = ActiveSupport::TaggedLogging.new(logger)

    # Load .env file
    Bundler.require(*Rails.groups)
    Dotenv::Railtie.load

  end
end
