redis_config = { host: '127.0.0.1', port: 6379, db: 0, namespace: 'sidekiq' }
Sidekiq.configure_server { |config| config.redis = redis_config }
Sidekiq.configure_client { |config| config.redis = redis_config }
Sidekiq::Logging.logger.level = Logger::INFO
