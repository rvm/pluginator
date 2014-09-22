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
require 'plugins/pluginator/extensions/class_exist'
require 'plugins/something/stats/max'

class ClassExistTester
  attr_accessor :plugins
  include Pluginator::Extensions::ClassExist
end

describe Pluginator::Extensions::ClassExist do
  subject do
    tester = ClassExistTester.new
    tester.plugins = { "stats" => [
      Something::Stats::Max
    ] }
    tester
  end

  it "plugin exists" do
    subject.class_exist?("stats", "max").must_equal( true )
  end

  it "plugin missing" do
    subject.class_exist?("stats", "min").must_equal( false )
  end
end
