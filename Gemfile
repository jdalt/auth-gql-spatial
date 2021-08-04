source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

group :development, :test, :staging do
  gem 'pry'
  gem 'pry-byebug'
end

# gem 'activerecord-import'
# gem 'activerecord_json_validator'
gem 'activerecord-mysql2rgeo-adapter'
gem 'batch-loader'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'graphiql-rails', '1.4.11' # pinned to this version until https://github.com/rmosolgo/graphiql-rails/issues/58 is fixed
gem 'graphql'
gem 'graphql-metrics'
gem 'jbuilder', '~> 2.7'
gem 'mysql2'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4'
gem 'rgeo', '2.2.0' # pinned to this version because 2.3.0 causes a "RGeo::Error::UnsupportedOperation: Method Surface#area not defined." error when running ./scripts/setup.sh
gem 'rgeo-geojson'
gem 'rgeo-proj4', '< 3'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
