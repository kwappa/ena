require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Ena
  class Application < Rails::Application
    config.autoload_paths += [
      Rails.root.join('lib/autoload'),
    ]
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.css *.js)
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.time_zone = 'Tokyo'

    config.generators do |g|
      g.template_engine = :haml
      g.test_framework  = :rspec
      g.stylesheets     = false
      g.javascripts     = false
      g.helper          = false
      g.view_specs      = false
    end

    # specify layout for devise
    config.to_prepare do
      Devise::SessionsController.layout 'users'
      Devise::RegistrationsController.layout 'users'
    end
  end
end
