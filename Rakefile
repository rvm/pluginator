require "rake/testtask"
task :default => [:test]
task :spec => :test
Rake::TestTask.new { |t| t.verbose, t.pattern = true, "test/**/test_*.rb" }
