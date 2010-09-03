require File.expand_path('test_helper', File.dirname(__FILE__))

class EnableFixturesForRegexpTest < ActiveSupport::TestCase

  enable_fixtures_for /posts|comments/

  def test_users
    assert_equal 0, User.find_all_by_email('ferko@suska.net').size
  end

  def test_posts
    assert_equal 3, Post.count
  end

  def test_comments
    assert_equal 5, Comment.all.size
  end

  test "no users found" do
    all_instances = User.find :all
    #assert_equal Array, all_instances.class
    assert_equal 0, all_instances.size
  end

end

class EnableFixturesForArrayOfNamesTest < ActiveSupport::TestCase

  enable_fixtures_for %W{ test_users }

  def test_users
    assert_equal 1, User.find_all_by_email('ferko@suska.net').size
  end

  def test_posts
    assert_equal 0, Post.count
  end

  def test_comments
    assert_equal 0, Comment.all.size
  end

end
