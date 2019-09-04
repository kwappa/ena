source 'https://rubygems.org'
# ruby '2.3.1'

gem 'rails'
gem 'sprockets'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'sdoc'
gem 'unicorn'

gem 'haml-rails'
gem 'bcrypt'
gem 'username_not_reserved_validator'
gem 'qiita-markdown'
gem 'diffy'
gem 'compass-rails'
gem 'kaminari'
gem 'font-awesome-rails'
gem 'pure-css-rails'

gem 'devise'
gem 'omniauth'
gem 'doorkeeper'
gem 'oauth2'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'erb2haml'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_bot_rails'
  gem 'sqlite3'
end

group :production, :test do
  gem 'pg'
end

group :test do
  gem 'database_rewinder'
  gem 'coveralls', require: false
  gem 'timecop'
  gem 'capybara'
end
