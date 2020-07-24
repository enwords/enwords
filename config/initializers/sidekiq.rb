redis_config = { url: ENV['REDIS_URL'], namespace: 'sidekiq' }
Sidekiq.configure_server { |config| config.redis = redis_config }
Sidekiq.configure_client { |config| config.redis = redis_config }

def redis_connected?
  Sidekiq.redis(&:info).present?
rescue Redis::CannotConnectError
  false
end
file = YAML.load_file('config/schedule.yml')
Sidekiq::Cron::Job.load_from_hash!(file) if redis_connected? && file
