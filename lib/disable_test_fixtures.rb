
module DisableTestFixtures

  @@last_test_loaded_fixtures = nil
  mattr_accessor :last_test_loaded_fixtures

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # accepts :
    # String/Symbol - test name
    # Array of strings/symbols - test names
    # Regexp - matching test names
    # Proc - will get test name passed
    # :all
    def disable_fixtures_for(tests = nil, &block)
      tests = tests.map { |e| e.to_s } if tests.is_a?(Array)
      tests = block if tests.nil? && block_given?
      @fixtures_disabled_tests = tests == :all ? true : tests
      #self.instance_variable_set(:@fixtures_disabled_tests, tests == :all ? true : tests)
    end

    # #deprecated
    def disable_fixtures(tests = true)
      @fixtures_disabled_tests = tests
    end

    def enable_fixtures
      @fixtures_disabled_tests = false
    end

    def fixtures_disabled?(test = nil)
      fixtures_disabled_tests = @fixtures_disabled_tests
      #fixtures_disabled_tests = self.instance_variable_get(:@fixtures_disabled_tests)
      if fixtures_disabled_tests.nil?
        superclass.respond_to?(:fixtures_disabled?) ?
          superclass.fixtures_disabled?(test) : false
      else
        case fixtures_disabled_tests
          when String then
            test == fixtures_disabled_tests
          when Symbol then
            test == fixtures_disabled_tests.to_s
          when Regexp then
            !!(test =~ fixtures_disabled_tests)
          when Array then
            #puts @fixtures_disabled_tests.inspect + ' : ' + test.inspect
            return fixtures_disabled_tests.include?(test)
          when Proc then
            fixtures_disabled_tests.arity == 1 ?
              fixtures_disabled_tests.call(test) :
                fixtures_disabled_tests.call
          else !!fixtures_disabled_tests
        end
      end
    end

  end

  def fixtures_disabled?
    self.class.fixtures_disabled?(method_name)
  end

  #def load_fixtures
  #  puts "load_fixtures() ..."
  #  super
  #end

  def setup_fixtures
    #puts "setup_fixtures() fixtures_disabled? = #{fixtures_disabled?}"

    unless fixtures_disabled?
      self.last_test_loaded_fixtures = true
      return super # default (real) setup_fixtures from TestFixtures
    end

    #puts "setup_fixtures() last_test_loaded_fixtures? = #{last_test_loaded_fixtures?}"
    if last_test_loaded_fixtures?
      # need to reset all loaded fixtures - empty the tables :
      unless (loaded_fixtures = already_loaded_fixtures).blank?
        clear_loaded_fixtures(loaded_fixtures)
      end
    end

    self.last_test_loaded_fixtures = false
    @fixture_cache = {} # fixture helpers should work and return nothing

    # begin transaction :
    if run_in_transaction?
      ActiveRecord::Base.connection.increment_open_transactions
      ActiveRecord::Base.connection.transaction_joinable = false
      ActiveRecord::Base.connection.begin_db_transaction
    else
      Fixtures.reset_cache # just to be sure ...
    end
    
  end

  private

  # TestFixtures internals !
  def already_loaded_fixtures
    begin
      ActiveRecord::TestFixtures.send(:class_variable_get, :@@already_loaded_fixtures)
    rescue NameError # might get here on first run in single test
      nil #{ self.class => {} }
    end
  end

  # TestFixtures internals !
  def clear_loaded_fixtures(already_loaded_fixtures)
    connection = ActiveRecord::Base.connection
    connection.transaction(:requires_new => true) do
      already_loaded_fixtures.values.each do |loaded_fixtures|
        next if loaded_fixtures.nil?
        loaded_fixtures.each_value do |fixtures|
          fixtures.delete_existing_fixtures
        end
      end
      #already_loaded_fixtures.values.each do |fixtures|
      #  fixtures.delete_existing_fixtures
      #end
      ##end
      ##
      # Cap primary key sequences to max(pk).
      if connection.respond_to?(:reset_pk_sequence!)
        fixture_table_names.each do |table_name|
          connection.reset_pk_sequence!(table_name)
        end
      end
    end

    already_loaded_fixtures.clear
    Fixtures.reset_cache # required to not break when multiple tests are run
  end

  #

  def last_test_loaded_fixtures?
    DisableTestFixtures.last_test_loaded_fixtures
  end

  def last_test_loaded_fixtures=(flag)
    DisableTestFixtures.last_test_loaded_fixtures = flag
  end

end

# make sure we have a method_name method
# NOTE: method_name is a attr_reader is Test::Unit::TestCase
# + if ActiveSupport::TestCase is being used it takes care for
# setting it up for MiniTest - thus this should happen rarely
#unless respond_to?(:method_name)
  # NOTE: minitest is auto-picked if ActiveSupport::TestCase is in use
  #if defined?(MiniTest::Assertions) #&& TestCase < MiniTest::Assertions
    #alias_method :method_name, :name if method_defined? :name
    #alias_method :method_name, :__name__ if method_defined? :__name__
  #else
    #def method_name
      #instance_variable_get(:@method_name) # "classic" test unit
    #end
  #end
#end
