require 'test_helper'
require 'plugins/pluginator/extensions/first_ask'
require 'plugins/something/stats/max'

module Something
  module Stats; end
end

class FirstAskTester
  attr_accessor :plugins
  include Pluginator::Extensions::FirstAsk
end

describe Pluginator::Extensions::FirstAsk do
  before do
    @tester = FirstAskTester.new
    @tester.plugins = { "stats" => [
      Something::Stats::Max
    ] }
  end

  it "finds existing plugin" do
    @tester.first_ask("stats", "handles?", "max").must_equal( Something::Stats::Max )
  end

  it "finds proper plugin" do
    @tester.first_ask("stats", "handles?", "max").action.must_equal( 42 )
  end

  it "finds existing plugin - no exception" do
    @tester.first_ask!("stats", "handles?", "max").must_equal( Something::Stats::Max )
  end

  it "does not find missing plugin - no exception" do
    @tester.first_ask("stats", "handles?", "min").must_equal( nil )
  end

  it "does not find missing plugin - exception plugin" do
    lambda {
      @tester.first_ask!("stats", "handles?", "min")
    }.must_raise(Pluginator::MissingPlugin)
  end
  it "does not find missing plugin - exception type" do
    lambda {
      @tester.first_ask!("stats2", "handles?", "max")
    }.must_raise(Pluginator::MissingType)
  end
end
