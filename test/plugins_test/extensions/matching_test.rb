require 'test_helper'
require 'plugins/pluginator/extensions/matching'

class MatchingTester
  attr_accessor :plugins
  include Pluginator::Extensions::Matching
end

describe Pluginator::Extensions::Matching do
  before do
    @tester = MatchingTester.new
    @tester.plugins = { "extensions" => [
      Pluginator::Extensions::PluginsMap,
      Pluginator::Extensions::Conversions,
      Pluginator::Extensions::Matching
    ] }
  end

  it "finds existing plugin" do
    @tester.matching("extensions", ["plugins_map"]).must_equal( [Pluginator::Extensions::PluginsMap] )
  end

  it "finds existing plugin - no exception" do
    @tester.matching!("extensions", ["plugins_map"]).must_equal( [Pluginator::Extensions::PluginsMap] )
  end

  it "does not find missing plugin - no exception" do
    @tester.matching("extensions", ["plugins_map2"]).must_equal( [nil] )
  end

  it "finds existing plugin" do
    lambda {
      @tester.matching!("extensions", ["plugins_map2"])
    }.must_raise(Pluginator::MissingPlugin)
  end
end
