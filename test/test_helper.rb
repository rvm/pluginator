=begin
Copyright 2013-2017
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

require "rubygems"
require "minitest"

# fix lib in LOAD_PATH and load version for gems manipulation
lib = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pluginator/version"

# remove old links in fake gem home
`rm -f #{File.expand_path("../gems/specifications/pluginator-*.gemspec", __FILE__)}`
`rm -f #{File.expand_path("../gems/gems/pluginator-*", __FILE__)}`

# create new links in fake gem home
File.symlink(File.expand_path("../../pluginator.gemspec", __FILE__), File.expand_path("../gems/specifications/pluginator-#{Pluginator::VERSION}.gemspec", __FILE__))
File.symlink(File.expand_path("../../", __FILE__), File.expand_path("../gems/gems/pluginator-#{Pluginator::VERSION}", __FILE__))

# register our own path with gems
# duplicate from Gemfile for non bundler
Gem.path << File.expand_path("../gems", __FILE__)
Gem.refresh

# register custom LOAD_PATH
load_path = File.expand_path("../gems/load_path", __FILE__)
$LOAD_PATH.push(load_path)

# make sure pluginator is available as gem for tests of pluginator plugins
#Gem::Specification.add_spec(Gem::Specification.load(File.expand_path("../gems/specifications/pluginator-#{Pluginator::VERSION}.gemspec", __FILE__)))
gem "pluginator"

if
  RUBY_VERSION.start_with?("2.4") && # check Gemfile
  $0 != "-e" # do not do that in guard
then
  require "coveralls"
  require "simplecov"

  SimpleCov.start do
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter,
    ])
    command_name "Unit Tests"
    add_filter "/test/"
  end

  Coveralls.noisy = true unless ENV["CI"]
end

# load everything
require "pluginator"
# Ensure all files are counted in
Dir[lib+"/**/*.rb"].each{|file| require file }

# We are removing paths from $LOAD_PATH,
# disabling verbose to not get warnings
# when the files are required again
$VERBOSE = false

module Something
  module Math; end
  module Stats; end
  module Nested
    module Structure; end
  end
end
module Activated
  module Version1; end
end
module Latest
  module Version1; end
  module Version2; end
end
module V1test
  module Stats; end
end
module V2test
  module Stats; end
end

require "minitest/autorun" unless $0=="-e" # skip in guard
require "minitest/unit"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
