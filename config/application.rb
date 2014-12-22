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
    config.generators.template_engine = :haml
    config.autoload_paths += [
      Rails.root.join('lib/autoload'),
    ]
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.css)
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  end
end
