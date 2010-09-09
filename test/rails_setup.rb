# enable testing with different version of rails via argv :
# ruby request_exception_handler_test.rb RAILS_VERSION=2.2.2

version =
  if ARGV.find { |opt| /RAILS_VERSION=([\d\.]+)/ =~ opt }
    $~[1]
  else
    # rake test RAILS_VERSION=2.3.5
    ENV['RAILS_VERSION']
  end

if version
  RAILS_VERSION = version
  gem 'activesupport', "= #{RAILS_VERSION}"
  gem 'activerecord', "= #{RAILS_VERSION}"
  gem 'actionpack', "= #{RAILS_VERSION}"
  gem 'actionmailer', "= #{RAILS_VERSION}"
  gem 'rails', "= #{RAILS_VERSION}"
else
  gem 'activesupport'
  gem 'activerecord'
  gem 'actionpack'
  gem 'actionmailer'
  gem 'rails'
end

require 'rails/version'
puts "emulating Rails.version = #{version = Rails::VERSION::STRING}"

require 'active_support'
require 'active_support/test_case'
if version >= '3.0.0'
  # otherwise require 'active_record/fixtures' fails in 3.0.0 !
  require 'active_support/core_ext/class/delegating_attributes'
end

require 'active_record'
require 'active_record/fixtures'
require 'active_record/test_case'

require 'action_controller'
require 'action_controller/test_case'
require 'action_controller/integration' if version < '3.0.0'

#require 'action_view/test_case'
#require 'action_mailer/test_case'

# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }
silence_warnings { RAILS_ROOT = File.dirname(__FILE__) }

module Rails
  class << self

    def initialized?
      @initialized || false
    end

    def initialized=(initialized)
      @initialized ||= initialized
    end

    def logger
      if defined?(RAILS_DEFAULT_LOGGER)
        RAILS_DEFAULT_LOGGER
      else
        nil
      end
    end

    def backtrace_cleaner
      @@backtrace_cleaner ||= begin
        require 'rails/gem_dependency' # backtrace_cleaner depends on this !
        require 'rails/backtrace_cleaner'
        Rails::BacktraceCleaner.new
      end
    end

    def root
      Pathname.new(RAILS_ROOT) if defined?(RAILS_ROOT)
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(RAILS_ENV)
    end

    def version
      VERSION::STRING
    end

    def public_path
      @@public_path ||= self.root ? File.join(self.root, "public") : "public"
    end

    def public_path=(path)
      @@public_path = path
    end
  end
end

class ActiveSupport::TestCase
  # only if defined e.g. Rails 2.2.3 monkey patches Test::Unit::TestCase :
  include ActiveRecord::TestFixtures if defined? ActiveRecord::TestFixtures

  #self.fixture_path = "#{RAILS_ROOT}/test/fixtures/"
  #self.use_instantiated_fixtures  = false
  #self.use_transactional_fixtures = true
  
end

ActionController::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

def create_fixtures(*table_names, &block)
  Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
end
