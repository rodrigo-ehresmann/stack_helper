# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Include FactoryGirl methods like 'create' and 'build'.
  config.include FactoryGirl::Syntax::Methods

  # Include Devise methods like 'sign_in'.
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Add to set Warden::Proxy (used in tests whit Devise).
  config.include Devise::Test::ControllerHelpers, type: :view

  # Add warden method like 'login_as' to use in integration tests.
  config.include Warden::Test::Helpers

  # Before the entire test suit runs, clear out the database.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Set default strategy.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # For tests flagged with ':js => true', transaction strategy doesn't work.
  # So set strategy to truncation.
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  # Start database cleaner strategy before each test.
  config.before(:each) do
    DatabaseCleaner.start
  end

  # Clean the database after each test.
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
