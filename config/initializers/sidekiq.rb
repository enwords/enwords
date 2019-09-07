redis_config = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
Sidekiq.configure_server { |config| config.redis = redis_config }
Sidekiq.configure_client { |config| config.redis = redis_config }
