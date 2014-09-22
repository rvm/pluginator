=begin
Copyright 2013
- Michal Papis <mpapis@gmail.com>
- Jordon Bedwell <envygeeks@gmail.com>

This file is part of pluginator.

pluginator is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

pluginator is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with pluginator.  If not, see <http://www.gnu.org/licenses/>.
=end

default_tasks = []

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.files   = ["lib/**/*.rb"]
    # TODO: see https://github.com/lsegal/yard/pull/800
    #t.stats_options = ["--list-undoc", "--compact"]
    t.options = ["--no-stats"]
    t.after = Proc.new do
      YARD::CLI::Stats.new.run("--list-undoc", "--compact")
    end
  end

  task :docs    => [:yard]
  default_tasks << :yard
rescue LoadError
end

require "rake/testtask"
Rake::TestTask.new do |t|
  t.verbose = true
  t.libs.push("test")
  t.pattern = "test/**/*_test.rb"
end
default_tasks << :test

task :default => default_tasks
