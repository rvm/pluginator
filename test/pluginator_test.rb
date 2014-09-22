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
require 'pluginator'

describe Pluginator do
  it :test_loads_plugins_automatically_for_group do
    pluginator = Pluginator.find("something")
    pluginator.types.must_include('stats')
    pluginator.types.must_include('math')
    pluginator.types.must_include('nested/structure')
    pluginator.types.size.must_equal(3)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  it :test_loads_plugins_automatically_for_group_type do
    pluginator = Pluginator.find("something", :type => "stats")
    pluginator.types.must_include('stats')
    pluginator.types.size.must_equal(1)
  end

  it :test_loads_existing_extensions_symbol do
    pluginator = Pluginator.find("something", :extends => :conversions)
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it :test_loads_nested_plugins do
    pluginator = Pluginator.find("something")
    pluginator.types.must_include('nested/structure')
    plugins = pluginator["nested/structure"].map(&:to_s)
    plugins.size.must_equal(1)
    plugins.must_include("Something::Nested::Structure::Test")
  end
end
