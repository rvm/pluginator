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
require "pluginator/autodetect"

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
    @math_parsed = [
      ["plugins/something/math/increase.rb", "something/math/increase", "math"],
      ["plugins/something/math/decrease.rb", "something/math/decrease", "math"]
    ]
    @math_files = gem_files(@math_parsed.map(&:first))
    @all_files = gem_files(
      "plugins/something/math/increase.rb", "plugins/something/math/decrease.rb",
      "plugins/something/nested/structure/test.rb", "plugins/something/stats/max.rb"
    )
  end

  describe :methods do
    before do
      @pluginator = Pluginator::Autodetect.allocate
      @pluginator.send(:setup_group, "something")
    end

    it :has_name do
      @pluginator.group.must_equal("something")
    end

    it :has_gem_file do
      File.exist?(gem_file("plugins/something/math/increase.rb")).must_equal(true)
    end

    it :finds_files_existing_group do
      @pluginator.instance_variable_set(:@force_type, nil)
      @pluginator.send(:find_files).sort.must_equal(@all_files.sort)
    end

    it :finds_files_group_and_missing_type do
      @pluginator.instance_variable_set(:@force_type, "none")
      @pluginator.send(:find_files).must_equal([])
    end

    it :finds_files_group_and_existing_type do
      @pluginator.instance_variable_set(:@force_type, "math")
      @pluginator.send(:find_files).sort.must_equal(@math_files.sort)
    end

    it :extracts_file_name_components do
      @pluginator.send(:split_file_name, "/path/to/plugins/group1/type1/name1.rb", "group1").
        must_equal(["plugins/group1/type1/name1.rb", "group1/type1/name1", "type1"])
    end

    it :builds_group_pattern do
      @pluginator.send(:file_name_pattern, "group2").must_equal("plugins/group2/**/*.rb")
    end

    it :builds_group_nil_pattern do
      @pluginator.send(:file_name_pattern, "group2").must_equal("plugins/group2/**/*.rb")
    end

    it :builds_group_type_pattern do
      @pluginator.send(:file_name_pattern, "group2", "type3").must_equal("plugins/group2/type3/*.rb")
    end

  end

  it :loads_plugins_automatically_for_group do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.types.must_include("stats")
    pluginator.types.must_include("math")
    pluginator.types.size.must_equal(3)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  it :loads_plugins_automatically_for_group_type do
    pluginator = Pluginator::Autodetect.new("something", :type => "stats")
    pluginator.types.must_include("stats")
    pluginator.types.size.must_equal(1)
  end

  it :makes_group_plugins_work do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.types.must_include("math")
    pluginator["math"].detect{|plugin| plugin.type == "increase" }.action(2).must_equal(3)
    pluginator["math"].detect{|plugin| plugin.type == "decrease" }.action(5).must_equal(4)
  end

  it :hides_methods do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.public_methods.map(&:to_sym).must_include(:register_plugin)
    pluginator.public_methods.map(&:to_sym).wont_include(:split_file_name)
  end

  it :has_no_type_when_not_forced do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.type.must_be_nil
  end

  it :defines_type_method_dynamically do
    pluginator = Pluginator::Autodetect.new("something", :type => "math")
    pluginator.type.wont_be_nil
    pluginator.type.must_equal(pluginator["math"])
  end

  it :loads_self do
    pluginator = Pluginator::Autodetect.new("pluginator")
    pluginator.types.must_include("extensions")
    pluginator.types.size.must_equal(1)
    plugins = pluginator["extensions"].map(&:to_s)
    assert plugins.size >= 6
    plugins.must_include("Pluginator::Extensions::ClassExist")
    plugins.must_include("Pluginator::Extensions::Conversions")
    plugins.must_include("Pluginator::Extensions::FirstAsk")
    plugins.must_include("Pluginator::Extensions::FirstClass")
    plugins.must_include("Pluginator::Extensions::Matching")
    plugins.must_include("Pluginator::Extensions::PluginsMap")
  end

end
