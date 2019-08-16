CarrierWave.configure do |config|
  config.permissions = 0644
  config.directory_permissions = 0755
  config.storage = :file
  config.enable_processing = false
  config.root = Rails.root
end
