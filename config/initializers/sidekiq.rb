require 'sidekiq'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
  config.redis = { size: 5, url: ENV['REDIS_URL'] }
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler, storage: :redis
  end
  config.redis = { size: 10, url: ENV['REDIS_URL'] }
end
