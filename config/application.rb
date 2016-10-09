require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InnaRails
  class Application < Rails::Application
    ENV['RAILS_ADMIN_THEME'] = 'rollincode'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += %W(#{config.root}/lib/search)
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.i18n.default_locale = :ru
    config.i18n.available_locales = :ru
    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

  end
end