=begin
Copyright 2013 Michal Papis <mpapis@gmail.com>

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

require 'test_helper'
require 'plugins/pluginator/extensions/plugins_map'

class PluginsMapTester
  attr_accessor :plugins
  include Pluginator::Extensions::PluginsMap
end

describe Pluginator::Extensions::PluginsMap do
  it "creates map" do
    tester = PluginsMapTester.new
    tester.plugins = { "extensions" => [Pluginator::Extensions::PluginsMap] }
    expected = { "PluginsMap" => Pluginator::Extensions::PluginsMap }
    tester.plugins_map("extensions").must_equal( expected )
  end
end
