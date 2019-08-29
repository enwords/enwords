def connected?
  !!Sidekiq.redis(&:info)
rescue
  false
end

Sidekiq::Cron::Job.load_from_hash(YAML.load_file('config/schedule.yml')) if connected?
