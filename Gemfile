source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails',        '4.2.0'
gem 'sprockets',    '~> 2.11.0'
gem 'sass-rails',   '~> 4.0.0'
gem 'uglifier',     '~> 2.7.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.2'
gem 'sdoc'
gem 'unicorn',      '~> 4.8.3'

gem 'haml-rails',   '~> 0.7.0'
gem 'bcrypt',       '~> 3.1.9'
gem 'username_not_reserved_validator'
gem 'qiita-markdown'
gem 'devise',       '~> 3.4.1'
gem 'omniauth',     '~> 1.2.2'
gem 'compass-rails'
gem 'kaminari'
gem 'font-awesome-rails'
gem 'pure-css-rails'

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
  gem 'factory_girl_rails'
  gem 'sqlite3', '~> 1.3.10'
end

group :production, :test do
  gem 'pg', '~> 0.18.0'
end

group :test do
  gem 'database_rewinder'
  gem 'coveralls', require: false
end
