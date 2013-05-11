require 'test_helper'
require 'plugins/pluginator/extensions/first_class'
require 'plugins/something/stats/max'

module Something
  module Stats; end
end

class FirstClassTester
  attr_accessor :plugins
  include Pluginator::Extensions::FirstClass
end

describe Pluginator::Extensions::FirstClass do
  before do
    @tester = FirstClassTester.new
    @tester.plugins = { "stats" => [
      Something::Stats::Max
    ] }
  end

  it "finds existing plugin" do
    @tester.first_class("stats", "max").must_equal( Something::Stats::Max )
  end

  it "finds proper plugin" do
    @tester.first_class("stats", "max").action.must_equal( 42 )
  end

  it "finds existing plugin - no exception" do
    @tester.first_class!("stats", "max").must_equal( Something::Stats::Max )
  end

  it "does not find missing plugin - no exception" do
    @tester.first_class("stats", "min").must_equal( nil )
  end

  it "does not find missing plugin - exception plugin" do
    lambda {
      @tester.first_class!("stats", "min")
    }.must_raise(Pluginator::MissingPlugin)
  end
  it "does not find missing plugin - exception type" do
    lambda {
      @tester.first_class!("stats2", "max")
    }.must_raise(Pluginator::MissingType)
  end
end
