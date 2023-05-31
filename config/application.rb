require_relative 'boot'
require 'rails/all'
require 'active_storage/attached'
require 'active_storage/engine'
require 'will_paginate/array'

WillPaginate.per_page = 10

ActiveSupport.on_load(:active_record) do
  include ActiveStorage::Reflection::ActiveRecordExtensions
  ActiveRecord::Reflection.singleton_class.prepend(ActiveStorage::Reflection::ReflectionExtension)
  include ActiveStorage::Attached::Model
end

Bundler.require(*Rails.groups)

module OnlineSellingScrape
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Karachi'
  end
end
