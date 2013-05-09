require 'minitest/autorun'
require 'pluginator/autodetect'

def demo_file(path)
  File.expand_path(File.join("..", "..", "demo", path), __FILE__)
end

def demo_files(*paths)
  paths.flatten.map{|path| demo_file(path) }
end

module Pluginator::Math; end

describe Pluginator::Autodetect do
  before do
    @demo_files = demo_files("plugins/pluginator/math/increase.rb", "plugins/pluginator/math/decrease.rb")
  end

  describe "separate" do
    before do
      @pluginator = Pluginator::Autodetect.allocate
      @pluginator.send(:setup, "pluginator")
    end

    it "has name" do
      @pluginator.group.must_equal("pluginator")
    end

    it "has demo file" do
      File.exists?(demo_file("plugins/pluginator/math/increase.rb")).must_equal(true)
    end

    it "loads file" do
      @pluginator.send(:load_plugin, "plugins/pluginator/math/increase.rb")
    end

    it "finds files" do
      @pluginator.send(:find_files).sort.must_equal(@demo_files.sort)
    end

    it "loads plugins" do
      @pluginator.send(:load_files, @demo_files)
      @pluginator.types.must_include('math')
      plugins = @pluginator["math"].map(&:to_s)
      plugins.size.must_equal(2)
      plugins.must_include("Pluginator::Math::Increase")
      plugins.must_include("Pluginator::Math::Decrease")
      plugins.wont_include("Pluginator::Math::Substract")
    end
  end

  it "loads plugins automatically" do
    pluginator = Pluginator::Autodetect.new("pluginator")
    pluginator.types.must_include('math')
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Pluginator::Math::Increase")
    plugins.must_include("Pluginator::Math::Decrease")
    plugins.wont_include("Pluginator::Math::Add")
  end

  it "makes plugins work" do
    pluginator = Pluginator::Autodetect.new("pluginator")
    pluginator["math"].detect{|plugin| plugin.type == "increase" }.action(2).must_equal(3)
    pluginator["math"].detect{|plugin| plugin.type == "decrease" }.action(5).must_equal(4)
  end

end
