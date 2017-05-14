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
require "plugins/pluginator/extensions/conversions"

class ConversionsTester
  extend Pluginator::Extensions::Conversions
end

describe Pluginator::Extensions::Conversions do
  it :class2string do
    ConversionsTester.class2string("SomethingLong").must_match("something_long")
  end

  it :string2class do
    ConversionsTester.string2class("something_long").must_match("SomethingLong")
  end
end
