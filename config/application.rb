require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Enwords
  class Application < Rails::Application
    config.autoload_paths += Dir.glob("#{config.root}/app/models/trainings")

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
