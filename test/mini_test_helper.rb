
require 'rbconfig'

module MiniTestHelper

  def self.enable_miniunit
    File.symlink File.join(minidir, "minitest"), File.join(sitelib, "minitest")
    File.symlink File.join(minidir, "test"), File.join(sitelib, "test")
    puts "enabled miniunit - added links to #{sitelib}"
  end

  def self.disable_miniunit
    File.unlink File.join(sitelib, "minitest")
    File.unlink File.join(sitelib, "test")
    puts "disabled miniunit - removed links from #{sitelib}"
  end

  private

  def self.minidir
    File.join(projdir, "lib")
  end

  def self.projdir
    use_minitest_path = Gem.bin_path('minitest_tu_shim', 'use_minitest')
    File.dirname(File.dirname(File.expand_path( use_minitest_path )))
  end

  def self.sitelib
    Config::CONFIG["sitelibdir"]
  end

end

require 'rubygems'

# NOTE: assuming testing on Ruby 1.8 !
#
# http://blog.floehopper.org/articles/2009/02/02/test-unit-and-minitest-with-different-ruby-versions
#
# sudo chmod a+rw /usr/local/lib/site_ruby/1.8 (sitelibdir)
#
def execute_with_minitest
  raise 'no block given' unless block_given?
  begin
    MiniTestHelper.enable_miniunit
    require 'test_helper'
    yield
  ensure
    MiniTestHelper.disable_miniunit
  end
end
