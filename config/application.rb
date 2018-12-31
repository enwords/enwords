require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Enwords
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
