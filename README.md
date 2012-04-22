DisableTestFixtures
===================

Rails plugin that disables fixture loading during test setup.
Tested with the built-in *Test::Unit* as well as with *MiniTest*.

Unit tests should be fast, active records (unless testing a complicated
non data dependent business logic) should be connected to a database, but
every time such a test method runs Rails will make sure Your fixtures are
correctly loaded (and there's no way turning it off for particular tests).

Until NOW ...

If You don't need fixtures in a test, You might turn them off easily.

NOTE: The plugin assumes transactional fixtures are being used - it can't
really help with instantiated fixture data !


Install
=======

    gem 'disable_test_fixtures'

or as a plain-old rails plugin :

    script/plugin install git://github.com/kares/disable_test_fixtures.git


Example
=======

    class UserTest < ActiveSupport::TestCase
      include DisableTestFixtures

      disable_fixtures_for %W{ test_create_a_user }

      test "create a user" do
        User.create! :name => 'Gregory House'
        assert_equal 1, User.count
      end

      # other test methods that use fixtures
      ...

    end

Of course, You might disable fixtures "globally" for all tests :

    # test_helper.rb

    class ActiveSupport::TestCase
      include DisableTestFixtures

      disable_fixtures_for :all

      # usual setup :
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures  = false
      ...

    end

If You have existing test cases that depend on fixtures You might enable the
fixtures support "back" in the concrete test cases :

    class FixturesDependentTest < ActiveSupport::TestCase

      # assuming fixtures were disabled in test_helper.rb

      enable_fixtures_for :all
      ...

    end


Sample speed improvement running a single test case from a fixture based setup
with fixtures disabled :

    Finished in 12.705094 seconds.

    49 tests, 200 assertions, 0 failures, 0 errors


    Finished in 3.015264 seconds.

    49 tests, 200 assertions, 0 failures, 0 errors


Your test will be faster and more readable if You don't use fixtures ...
Try the factory pattern for creating the data You need in every scenario.

[Test Factory](http://www.dcmanges.com/blog/38)

[Factory Girl](http://github.com/thoughtbot/factory_girl)

NOTE: BE CAREFUL WHEN MIXING TESTS THAT EXPECT AN EMPTY DB WITH TESTS THAT
DEPEND ON FIXTURES, YOU MIGHT NEED TO MAKE SURE YOUR DB IS CLEAN BEFORE EACH
AND EVERY CONSECUTIVE RUN (NO FIXTURES LEFT FROM A PREVIOUS TEST FAILURE).

<http://blog.kares.org/search/label/disable_test_fixtures>
