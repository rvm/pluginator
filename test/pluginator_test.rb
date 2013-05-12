require 'test_helper'
require 'pluginator'

class PluginatorTest < MiniTest::Unit::TestCase
  def test_loads_plugins_automatically_for_group
    pluginator = Pluginator.find("something")
    pluginator.types.must_include('stats')
    pluginator.types.must_include('math')
    pluginator.types.size.must_equal(2)
    plugins = pluginator["math"].map(&:to_s)
    plugins.size.must_equal(2)
    plugins.must_include("Something::Math::Increase")
    plugins.must_include("Something::Math::Decrease")
    plugins.wont_include("Something::Math::Add")
  end

  def test_loads_plugins_automatically_for_group_type
    pluginator = Pluginator.find("something", type: "stats")
    pluginator.types.must_include('stats')
    pluginator.types.size.must_equal(1)
  end

  def test_loads_existing_extensions_symbol
    pluginator = Pluginator.find("something", extends: :conversions)
    pluginator.public_methods.must_include(:class2string)
    pluginator.public_methods.must_include(:string2class)
    pluginator.public_methods.wont_include(:plugins_map)
  end
end
