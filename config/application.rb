require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Enwords
  class Application < Rails::Application
    config.autoload_paths += Dir.glob("#{config.root}/app/models/trainings")
    config.application = config_for(:application)
    config.languages = config_for(:languages)
    config.active_record.schema_format = :sql
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.orm :active_record, force_foreign_key_type: :uuid
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
