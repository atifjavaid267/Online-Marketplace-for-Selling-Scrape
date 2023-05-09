require_relative "boot"

require "rails/all"

require "active_storage/attached"
require "active_storage/engine"

require 'will_paginate/array'

ActiveSupport.on_load(:active_record) do
  include ActiveStorage::Reflection::ActiveRecordExtensions
  ActiveRecord::Reflection.singleton_class.prepend(ActiveStorage::Reflection::ReflectionExtension)
  include ActiveStorage::Attached::Model
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OnlineSellingScrape
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # config/application.rb
    # config.middleware.use ActionCable.server
    # config.action_controller.default_protect_from_forgery = true
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
