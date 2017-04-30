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
require "pluginator/extendable_autodetect"

describe Pluginator::ExtendableAutodetect do
  it :loads_existing_extensions_array do
    pluginator = Pluginator::ExtendableAutodetect.new("something", :extends => [:conversions])
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it :loads_existing_extensions_symbol do
    pluginator = Pluginator::ExtendableAutodetect.new("something", :extends => :conversions)
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it :fails_to_load_missing_extension do
    lambda {
      Pluginator::ExtendableAutodetect.new("something", :extends => [:missing_conversions])
    }.must_raise(Pluginator::MissingPlugin)
  end
end
