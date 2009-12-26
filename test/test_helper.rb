require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require 'active_record'
require 'action_controller'
require 'action_view'

DATA_DIRECTORY = File.join(File.dirname(__FILE__), 'data')

ActiveRecord::Migration.verbose = false # quiet down the migration engine
ActiveRecord::Base.configurations = { 'test' => {
    'adapter' => 'sqlite3', 'database' => ':memory:'
}} # when configurations are empty fixtures are not setup !
ActiveRecord::Base.establish_connection('test')
ActiveRecord::Base.silence do
  load File.join(DATA_DIRECTORY, 'schema.rb')
end

require 'rails_setup' # makes test case load fixtures just like in rails
require 'data/models' # test active record model classes

require File.join(File.dirname(__FILE__), '../lib/disable_test_fixtures')

class ActiveSupport::TestCase

  include DisableTestFixtures

  self.fixture_path = "#{DATA_DIRECTORY}/fixtures/"

  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

end