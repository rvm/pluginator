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
require 'pluginator/group'

describe Pluginator::Group do
  it "has name" do
    Pluginator::Group.new("something").group.must_equal("something")
  end

  describe "plugins list" do
    before do
      @group = Pluginator::Group.new("something")
    end

    it "adds type" do
      @group.register_plugin("type1", nil)
      @group.types.must_include("type1")
      @group.types.wont_include("type2")
    end

    it "adds plugin" do
      @group.register_plugin("type1", "test1")
      @group["type1"].must_include("test1")
      @group["type1"].wont_include("test2")
    end
  end
end
