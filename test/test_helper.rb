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

# register our own path with gems
# duplicate from Gemfile for non bundler
Gem.path << File.expand_path("../gems", __FILE__)
Gem.refresh

if
  RUBY_VERSION == "2.0.0" # check Gemfile
then
  require "coveralls"
  require "simplecov"

  SimpleCov.start do
    formatter SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter,
    ]
    command_name "Unit Tests"
    add_filter "/test/"
    add_filter "/demo/"
  end

  Coveralls.noisy = true unless ENV['CI']
end

module Something
  module Math; end
  module Stats; end
  module Nested
    module Structure; end
  end
end

require 'minitest/autorun'
require 'minitest/unit'
