Rails.application.configure do
  default_url_options[:host] = 'enwords.app'
  config.cache_classes = true
  config.eager_load = false
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.cache_store = :redis_store, { url: ENV['REDIS_URL'], namespace: 'web' }
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
  config.i18n.default_locale = :en
  config.i18n.fallbacks = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'enwords.app' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default charset: 'utf-8'
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'],
    port: ENV['SMTP_PORT'],
    domain: ENV['SMTP_DOMAIN'],
    user_name: ENV['SMTP_USER_NAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
  }
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    email: {
      email_prefix: '[Enwords][ERROR] ',
      sender_address: %('Enwords Notifier' <noreply@enwords.app>),
      exception_recipients: [ENV['EXCEPTION_RECIPIENT']]
    }
  )
end
