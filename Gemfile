source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'


gem 'mustache-rails', :require => 'mustache/railtie'
gem 'cancan'
gem 'will_paginate'
gem 'acts-as-taggable-on', '~> 2.4.1'
gem "friendly_id", "~> 4.0.9"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.0.1'
gem 'sunspot_rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'
  gem 'rmagick'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
end

# gem 'paperclip'
gem 'devise'
gem 'simple_form'
# gem 'wicked_pdf'
gem 'twilio-ruby'

gem 'accountable', '1.0.1', :git => "git://github.com/alexthomas/accountable.git"
gem 'videoable', '1.0.1',:git => "git://github.com/alexthomas/videoable.git"
gem 'twilio', '0.0.1',:git => "git://github.com/alexthomas/twilio.git"


gem 'redis'
gem 'redis-namespace'
gem 'resque', :require => 'resque/server'

gem 'tinymce-rails'

group :development do
  # gem 'localtunnel'
  gem 'rspec-rails'
  gem 'sunspot_solr'
  gem 'faker'
  gem 'annotate'
  # gem 'thin'
  # gem 'private_pub'
  # gem 'cocaine', '0.3.2'
end

group :production, :stage do
  #gem 'sunspot_rails'
  gem 'memcache-client'
  # gem 'wkhtmltopdf-binary'
  gem 'mysql2'
  #gem 'newrelic_rpm'
end

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem 'capistrano-resque'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
#   gem 'webrat'
	#gem 'turn', :require => false
	gem 'sqlite3'
end

# Use unicorn as the app server
gem 'unicorn'
