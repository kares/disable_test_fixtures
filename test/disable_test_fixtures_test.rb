
require 'rubygems'
#require 'active_support'
require 'active_support/core_ext/module'
require 'test/unit'

require File.join(File.dirname(__FILE__), '../lib/disable_test_fixtures')

class DisableTestFixturesTest < Test::Unit::TestCase

  class TheTest
    include DisableTestFixtures
  end

  def test_responds_to_disable_fixtures_for?
    assert TheTest.respond_to? :disable_fixtures_for
  end

  def test_responds_to_enable_fixtures_for?
    assert TheTest.respond_to? :enable_fixtures_for
  end

  class DisableAllTest
    include DisableTestFixtures
    disable_fixtures_for :all
  end

  def test_disable_all_fixtures_disabled?
    assert DisableAllTest.fixtures_disabled?('test_method')
  end

  class EnableAllTest
    include DisableTestFixtures
    enable_fixtures_for :all
  end

  def test_enable_all_fixtures_disabled?
    assert ! EnableAllTest.fixtures_disabled?('test_method')
  end

  class DisableAllInheritedTest < DisableAllTest; end

  def test_inherited_disable_all_fixtures_disabled?
    assert DisableAllInheritedTest.fixtures_disabled?('test_method')
  end

  class EnableAllInheritedTest < EnableAllTest; end

  def test_inherited_enable_all_fixtures_disabled?
    assert ! EnableAllInheritedTest.fixtures_disabled?('test_method')
  end

  class DisableEqualTest
    include DisableTestFixtures
    disable_fixtures_for [ 'test_method' ]
  end

  def test_disable_equal_fixtures_disabled?
    assert DisableEqualTest.fixtures_disabled?('test_method')
    assert ! DisableEqualTest.fixtures_disabled?('test_other_method')
  end

  class DisableMatchTest
    include DisableTestFixtures
    disable_fixtures_for /test_method/
  end

  def test_disable_match_fixtures_disabled?
    assert DisableMatchTest.fixtures_disabled?('test_method')
    assert DisableMatchTest.fixtures_disabled?('test_method_another')
    assert ! DisableMatchTest.fixtures_disabled?('test_other_method')
  end

  class EnableEqualTest
    include DisableTestFixtures
    enable_fixtures_for [ 'test_method' ]
  end

  def test_disable_equal_fixtures_disabled?
    assert ! EnableEqualTest.fixtures_disabled?('test_method')
    assert EnableEqualTest.fixtures_disabled?('test_other_method')
  end

end
