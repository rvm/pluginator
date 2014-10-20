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

require "test_helper"
require "pluginator"

describe Pluginator do
  it "loads_plugins_automatically_for_group" do
    pluginator = Pluginator.find("something")
    pluginator.types.must_include("stats")
    pluginator.types.must_include("math")
    pluginator.types.must_include("nested/structure")
    pluginator.types.size.must_equal(3)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  it "loads_plugins_automatically_for_group_type" do
    pluginator = Pluginator.find("something", :type => "stats")
    pluginator.types.must_include("stats")
    pluginator.types.size.must_equal(1)
  end

  it "loads_existing_extensions_symbol" do
    pluginator = Pluginator.find("something", :extends => :conversions)
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it "loads_nested_plugins" do
    pluginator = Pluginator.find("something")
    pluginator.types.must_include("nested/structure")
    pluginator["nested/structure"].map(&:to_s).must_equal(["Something::Nested::Structure::Test"])
  end

  it "loads_only_plugins_from_latest_version_of_gem" do
    all_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" }
    all_gems.must_include("fake-gem-name-latest-1.0.0")
    all_gems.must_include("fake-gem-name-latest-2.0.0")
    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.wont_include("fake-gem-name-latest-1.0.0")
    active_gems.wont_include("fake-gem-name-latest-2.0.0")

    pluginator = Pluginator.find("latest")

    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.wont_include("fake-gem-name-latest-1.0.0")
    active_gems.must_include("fake-gem-name-latest-2.0.0")

    pluginator.types.must_include("version2")
    pluginator.types.wont_include("version1")
    pluginator.types.size.must_equal(1)
    pluginator["version2"].map(&:to_s).must_equal(["Latest::Version2::Max"])
  end

  it "loads_latest_version_of_plugin_from_two_gems_v1" do
    all_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" }
    all_gems.must_include("fake-gem-name-v1a-1.0.0")
    all_gems.must_include("fake-gem-name-v1b-1.0.0")
    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.wont_include("fake-gem-name-v1a-1.0.0")

    pluginator = Pluginator.find("v1test")

    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.wont_include("fake-gem-name-v1a-1.0.0")
    active_gems.must_include("fake-gem-name-v1b-1.0.0")

    pluginator.types.must_include("stats")
    pluginator.types.size.must_equal(1)
    pluginator["stats"].map(&:to_s).must_equal(["V1test::Stats::Max"])
    pluginator["stats"].first.action.must_equal(42)
  end

  it "loads_latest_version_of_plugin_from_two_gems_v2" do
    all_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" }
    all_gems.must_include("fake-gem-name-v2a-1.0.0")
    all_gems.must_include("fake-gem-name-v2b-1.0.0")
    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.wont_include("fake-gem-name-v2a-1.0.0")

    pluginator = Pluginator.find("v2test")

    active_gems = Gem::Specification._all.map{|s| "#{s.name}-#{s.version}" if s.activated? }.compact
    active_gems.must_include("fake-gem-name-v2a-1.0.0")
    active_gems.wont_include("fake-gem-name-v2b-1.0.0")

    pluginator.types.must_include("stats")
    pluginator.types.size.must_equal(1)
    pluginator["stats"].map(&:to_s).must_equal(["V2test::Stats::Max"])
    pluginator["stats"].first.action.must_equal(41)
  end
end
