require "bundler/gem_tasks"
require "rake/testtask"
require "cucumber"
require "cucumber/rake/task"

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -x"
  t.fork = false
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => [:test, :features]

# test with code coverage
namespace :test do
  desc "Run all tests and generate a code coverage report (simplecov)"
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['test'].execute
  end
end

# generate docs
require 'rdoc/task'
RDoc::Task.new do |rd|
  rd.main     = "README.md"
  rd.title    = 'lifx_dash'
  rd.rdoc_dir = 'doc'
  rd.options  << "--all"
  rd.rdoc_files.include("README.md", "LICENSE.txt", "lib/**/*.rb", "bin/**/*")
end
