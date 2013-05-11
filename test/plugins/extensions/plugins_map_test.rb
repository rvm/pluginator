require 'test_helper'
require 'plugins/pluginator/extensions/plugins_map'

class PluginsMapTester
  attr_accessor :plugins
  include Pluginator::Extensions::PluginsMap
end

describe Pluginator::Extensions::PluginsMap do
  it "creates map" do
    tester = PluginsMapTester.new
    tester.plugins = { "extensions" => [Pluginator::Extensions::PluginsMap] }
    expected = { "PluginsMap" => Pluginator::Extensions::PluginsMap }
    tester.plugins_map("extensions").must_equal( expected )
  end
end
