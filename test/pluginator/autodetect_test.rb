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
require 'pluginator/autodetect'

def gem_file(path, options = {})
  options.merge!({
    :gem_name    => "fake-gem-name-a",
    :gem_version => "1.0.0",
  })
  File.expand_path(
    File.join(
      "../../gems/gems/#{options[:gem_name]}-#{options[:gem_version]}/lib",
      path
    ),
    __FILE__
  )
end

def gem_files(*paths)
  options = paths.last.is_a?(::Hash) ? paths.pop : {}
  paths.flatten.map{|path| gem_file(path, options) }
end

describe Pluginator::Autodetect do
  before do
    @math_files = gem_files("plugins/something/math/increase.rb", "plugins/something/math/decrease.rb")
    @all_files = gem_files(
      "plugins/something/math/increase.rb", "plugins/something/math/decrease.rb",
      "plugins/something/nested/structure/test.rb", "plugins/something/stats/max.rb"
    )
  end

  describe "separate" do
    before do
      @pluginator = Pluginator::Autodetect.allocate
      @pluginator.send(:setup_group, "something")
    end

    it "has name" do
      @pluginator.group.must_equal("something")
    end

    it "has gem file" do
      File.exists?(gem_file("plugins/something/math/increase.rb")).must_equal(true)
    end

    it "loads plugin" do
      @pluginator.send(:load_plugin, "plugins/something/math/increase.rb").must_equal(true)
    end

    it "finds files existing group" do
      @pluginator.send(:find_files).sort.must_equal(@all_files.sort)
    end

    it "finds files group and missing type" do
      @pluginator.instance_variable_set(:@force_type, "none")
      @pluginator.send(:find_files).must_equal([])
    end

    it "finds files group and existing type" do
      @pluginator.instance_variable_set(:@force_type, "math")
      @pluginator.send(:find_files).sort.must_equal(@math_files.sort)
    end

    it "finds files group and existing type" do
      @pluginator.send(:force_type, "math")
      @pluginator.type.must_equal( @pluginator["math"] )
    end

    it "loads files" do
      @pluginator.send(:load_files, @math_files)
      @pluginator.types.must_include('math')
      plugins = @pluginator["math"].map(&:to_s)
      plugins.size.must_equal(2)
      plugins.must_include("Something::Math::Increase")
      plugins.must_include("Something::Math::Decrease")
      plugins.wont_include("Something::Math::Substract")
    end
  end

  it "loads plugins automatically for group" do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.types.must_include('stats')
    pluginator.types.must_include('math')
    pluginator.types.size.must_equal(3)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  it "loads plugins automatically for group/type" do
    pluginator = Pluginator::Autodetect.new("something", :type => "stats")
    pluginator.types.must_include('stats')
    pluginator.types.size.must_equal(1)
  end

  it "makes group plugins work" do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.types.must_include('math')
    pluginator["math"].detect{|plugin| plugin.type == "increase" }.action(2).must_equal(3)
    pluginator["math"].detect{|plugin| plugin.type == "decrease" }.action(5).must_equal(4)
  end

  it "hides methods" do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.public_methods.map(&:to_sym).must_include(:register_plugin)
    pluginator.public_methods.map(&:to_sym).wont_include(:load_plugins)
    pluginator.public_methods.map(&:to_sym).wont_include(:split_file_name)
    pluginator.type.must_equal(nil)
  end

  it "defines type method dynamically" do
    pluginator = Pluginator::Autodetect.new("something", :type => 'math')
    pluginator.type.must_equal(pluginator['math'])
  end

  it "loads self" do
    pluginator = Pluginator::Autodetect.new("pluginator")
    pluginator.types.must_include('extensions')
    pluginator.types.size.must_equal(1)
    pluginator["extensions"].map(&:to_s).sort.must_equal([
      "Pluginator::Extensions::ClassExist",
      "Pluginator::Extensions::Conversions",
      "Pluginator::Extensions::FirstAsk",
      "Pluginator::Extensions::FirstClass",
      "Pluginator::Extensions::Matching",
      "Pluginator::Extensions::PluginsMap"
    ])
  end

end
