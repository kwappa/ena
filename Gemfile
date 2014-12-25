source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails',        '4.2.0'
gem 'sass-rails',   '~> 5.0.0'
gem 'uglifier',     '~> 2.6.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.2'
gem 'sdoc'

gem 'haml-rails',   '~> 0.6.0'
gem 'bcrypt',       '~> 3.1.9'
gem 'username_not_reserved_validator'
gem 'qiita-markdown'
gem 'devise',       '~> 3.4.1'
gem 'omniauth',     '~> 1.2.2'

group :production do
  gem 'pg',             '~> 0.17.1'
  gem 'rails_12factor', '~> 0.0.3'
end

group :development do
  gem 'sqlite3',      '~> 1.3.10'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'erb2haml'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_rewinder'
end
