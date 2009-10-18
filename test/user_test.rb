require 'test_helper'

class UserTest < ActiveSupport::TestCase

  disable_fixtures_for :all

  def test_users_1
    User.create! :name => 'User 1', :email => 'user1@test.me'

    assert_equal 1, User.all.size
  end

  def test_users_2
    User.create! :name => 'User 1', :email => 'user1@test.me'
    User.create! :name => 'User 2', :email => 'user2@test.me'

    assert_equal 2, User.count
  end

  def test_users_3
    User.create! :name => 'User 1', :email => 'user1@test.me'
    User.create! :name => 'User 2', :email => 'user2@test.me'
    User.create! :name => 'User 3', :email => 'user3@test.me'

    assert_not_nil User.first
    assert_not_equal User.first, User.last

    assert_equal 3, User.count
  end

  def test_users_0
    assert_equal [], User.find(:all)
  end

end
