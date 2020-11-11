source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails',        '4.2.7.1'
gem 'sprockets',    '~> 2.11.0'
gem 'sass-rails',   '~> 5.0.1'
gem 'uglifier',     '~> 2.7.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.1.0'
gem 'sdoc'
gem 'unicorn',      '~> 5.0.0'

gem 'haml-rails',   '~> 0.9.0'
gem 'bcrypt',       '~> 3.1.9'
gem 'username_not_reserved_validator'
gem 'qiita-markdown'
gem 'diffy',        '~> 3.1.0'
gem 'compass-rails', '~> 2.0.4'
gem 'kaminari'
gem 'font-awesome-rails'
gem 'pure-css-rails'

gem 'devise',       '~> 3.5.0'
gem 'omniauth',     '~> 1.9.1'
gem 'doorkeeper',   '~> 2.1.1'
gem 'oauth2',       '~> 1.0.0'

group :production do
  gem 'rails_12factor', '~> 0.0.3'
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
  gem 'factory_girl_rails'
  gem 'sqlite3', '~> 1.3.10'
end

group :production, :test do
  gem 'pg', '~> 0.18.0'
end

group :test do
  gem 'database_rewinder'
  gem 'coveralls', require: false
  gem 'timecop'
  gem 'capybara'
end
