# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "disable_test_fixtures"
  s.version     = '0.2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karol Bucek"]
  s.email       = ["self@kares.org"]
  s.homepage    = "http://github.com/kares/disable_test_fixtures"
  s.summary     = "Rails plugin that disables fixture loading during test setup."
  s.description = "Unit tests should be fast, active records (unless testing a complicated " + 
    "non data dependent business logic) should be connected to a database, but " + 
    "every time such a test method runs Rails will make sure Your fixtures are " + 
    "correctly loaded (and there's no way turning it off for particular tests)."
 
  s.files        = Dir.glob("lib/*") + %w( LICENSE README.md Rakefile )
  s.require_path = 'lib'
  s.test_files   = Dir.glob("test/*.rb")
 
  s.add_dependency 'actionpack', '>= 2.3'
  s.add_development_dependency "mocha"
  
  s.extra_rdoc_files = [ "README.md" ]
  s.rubyforge_project = '[none]'
end