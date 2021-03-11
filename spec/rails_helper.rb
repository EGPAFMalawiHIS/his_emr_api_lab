# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'
# Add additional requires below this line. Rails is not loaded until this point!

# ActiveRecord::Base.logger = Logger.new(STDOUT)
# ActiveRecord::Base.logger.level = :debug

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
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.load_schema_if_pending!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
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

  config.include FactoryBot::Syntax::Methods
end

require 'shoulda-matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

def create_order(patient, seq: 0, add_result: false)
  encounter = create(:encounter, patient: patient)

  order = create(:order, order_type: create(:order_type, name: Lab::Metadata::ORDER_TYPE_NAME),
                         encounter: encounter,
                         patient: patient,
                         start_date: Date.today + seq.days,
                         accession_number: SecureRandom.uuid)
  test = create(:observation, order: order,
                              encounter: encounter,
                              person_id: patient.patient_id,
                              concept_id: create(:concept_name, name: Lab::Metadata::TEST_TYPE_CONCEPT_NAME).concept_id,
                              value_coded: create(:concept_name).concept_id)

  create(:observation, order: order,
                       encounter: encounter,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::TARGET_LAB_CONCEPT_NAME).concept_id,
                       value_text: Faker::Address.city)

  create(:observation, order: order,
                       encounter: encounter,
                       person_id: patient.patient_id,
                       concept_id: create(:concept_name, name: Lab::Metadata::REASON_FOR_TEST_CONCEPT_NAME).concept_id,
                       value_coded: create(:concept_name, name: 'Routine').concept_id)

  return order unless add_result

  create(:observation, order: order,
                       encounter: create(:encounter, patient: patient),
                       concept_id: create(:concept_name, name: Lab::Metadata::LAB_TEST_RESULT_CONCEPT_NAME).concept_id,
                       person_id: patient.patient_id,
                       obs_group_id: test.obs_id,
                       value_modifier: '=',
                       value_text: '200')

  order
end
