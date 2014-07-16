Myapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Supress logging
  config.assets.logger = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Base URL for development
  BASE_URL = ENV['BASE_URL'] || "http://127.0.0.1:3000"

  # Default Feed for Scans
  DEFAULT_FEED = "EM-765156739"

  # DIV Container ID
  DIV_CONTAINER_ID = "r7btestresult"

  # Product name
  PRODUCT_NAME = "PluginScan"

  # Disable DNT given its broken implementation (IE/FF on by default)
  CHECK_DNT = false

  VULN_DB_SOURCE = "#{Rails.root}/config/vdb_pluginscan.json"
end
