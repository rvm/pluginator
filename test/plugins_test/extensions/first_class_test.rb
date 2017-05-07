=begin
Copyright 2013-2017 Michal Papis <mpapis@gmail.com>

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

require "test_helper"
require "plugins/pluginator/extensions/first_class"
require "plugins/something/stats/max"

class FirstClassTester
  attr_accessor :plugins
  include Pluginator::Extensions::FirstClass
end

describe Pluginator::Extensions::FirstClass do
  before do
    @tester = FirstClassTester.new
    @tester.plugins = { "stats" => [
      Something::Stats::Max
    ] }
  end

  it :finds_existing_plugin do
    @tester.first_class("stats", "max").must_equal( Something::Stats::Max )
  end

  it :finds_proper_plugin do
    @tester.first_class("stats", "max").action.must_equal( 42 )
  end

  it :finds_existing_plugin_no_exception do
    @tester.first_class!("stats", "max").must_equal( Something::Stats::Max )
  end

  it :does_not_find_missing_plugin_no_exception do
    @tester.first_class("stats", "min").must_be_nil
  end

  it :does_not_find_missing_plugin_exception_plugin do
    lambda {
      @tester.first_class!("stats", "min")
    }.must_raise(Pluginator::MissingPlugin)
  end
  it :does_not_find_missing_plugin_exception_type do
    lambda {
      @tester.first_class!("stats2", "max")
    }.must_raise(Pluginator::MissingType)
  end
end
