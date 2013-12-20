require 'test_helper'
require 'plugins/pluginator/extensions/class_exist'
require 'plugins/something/stats/max'

module Something
  module Stats; end
end

class ClassExistTester
  attr_accessor :plugins
  include Pluginator::Extensions::ClassExist
end

class Pluginator::Extensions::ClassExistTest < MiniTest::Unit::TestCase
  def setup
    @tester = ClassExistTester.new
    @tester.plugins = { "stats" => [
      Something::Stats::Max
    ] }
  end

  def test_plugin_exist
    @tester.class_exist?("stats", "max").must_equal( true )
  end

  def test_plugin_missing
    @tester.class_exist?("stats", "min").must_equal( false )
  end
end
