require 'minitest/autorun'
require 'pluginator/autodetect'

module Something
  module Math; end
  module Stats; end
end

def demo_file(path)
  File.expand_path(File.join("..", "..", "demo", path), __FILE__)
end

def demo_files(*paths)
  paths.flatten.map{|path| demo_file(path) }
end

describe Pluginator::Autodetect do
  before do
    @math_files = demo_files("plugins/something/math/increase.rb", "plugins/something/math/decrease.rb")
    @all_files = demo_files("plugins/something/math/increase.rb", "plugins/something/math/decrease.rb", "plugins/something/stats/max.rb")
  end

  describe "separate" do
    before do
      @pluginator = Pluginator::Autodetect.allocate
      @pluginator.send(:setup_group, "something")
    end

    it "has name" do
      @pluginator.group.must_equal("something")
    end

    it "has demo file" do
      File.exists?(demo_file("plugins/something/math/increase.rb")).must_equal(true)
    end

    it "loads plugin" do
      @pluginator.send(:load_plugin, "plugins/something/math/increase.rb")
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
      @pluginator.instance_variable_set(:@force_type, "math")
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
    pluginator.types.size.must_equal(2)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  it "loads plugins automatically for group/type" do
    pluginator = Pluginator::Autodetect.new("something", type: "stats")
    pluginator.types.must_include('stats')
    pluginator.types.size.must_equal(1)
  end

  it "makes group plugins work" do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator["math"].detect{|plugin| plugin.type == "increase" }.action(2).must_equal(3)
    pluginator["math"].detect{|plugin| plugin.type == "decrease" }.action(5).must_equal(4)
  end

  it "hides methods" do
    pluginator = Pluginator::Autodetect.new("something")
    pluginator.public_methods.must_include(:register_plugin)
    pluginator.public_methods.wont_include(:load_plugins)
    pluginator.public_methods.wont_include(:split_file_name)
  end

end
