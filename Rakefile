require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |t|
  t.verbose = true
  t.libs.push("demo")
  t.pattern = "test/**/*_test.rb"
end
