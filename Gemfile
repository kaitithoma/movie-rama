source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Json Web Token (JWT) for user authentication
gem "jwt"

# Encrypt/decrypt passwords for user authentication
gem "bcrypt"

# Use kaminari for pagination
# gem "kaminari"

# Use scenic for database views
gem "scenic"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use faker for generating fake data through seeds file
  gem "faker"

  # Unit tests
  gem "rspec-rails", "~> 7.0.0"

  # Use factory_bot for generating fake data in tests
  gem "factory_bot_rails"

  gem "rubocop"

  # Use simplecov for code coverage
  gem "simplecov", "~> 0.22", require: false
  gem "simplecov-lcov", "~> 0.8", require: false
  gem "simplecov-rcov", git: "https://github.com/k0kubun/simplecov-rcov", branch: "binary-write", require: false
  gem "rswag-specs"
  gem "shoulda-matchers", "~> 6.0"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  # Use pry for debugging
  gem "pry-nav"
  gem "pry-rails"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
end

# gem "gem", "~> 0.0.1.alpha"
gem "jsonapi-serializer", "~> 2.2"

# gem "gem", "~> 0.0.1.alpha"
gem "ruby2_keywords", "~> 0.0.5"
