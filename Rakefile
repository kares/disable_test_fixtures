require 'rake'

task :default => :test

require 'rake/testtask'
desc 'Run Unit Tests'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

require 'rdoc/task'
desc 'Generate Documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DisableTestFixtures'
  rdoc.options << '--line-numbers' << '--inline-source'
  #rdoc.rdoc_files.include('README.md')
  #rdoc.rdoc_files.include('lib/**/*.rb')
end
