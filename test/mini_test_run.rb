require 'test_helper'
require 'mini_test_helper'

# run all tests with mini_test :
tests = Dir.glob('*_test.rb')
execute_with_minitest do
  tests.each { |test| load test }
end
