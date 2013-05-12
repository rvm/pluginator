require 'test_helper'
require 'pluginator'

describe Pluginator do
  it "loads plugins automatically for group" do
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

  it "loads plugins automatically for group/type" do
    pluginator = Pluginator.find("something", type: "stats")
    pluginator.types.must_include('stats')
    pluginator.types.size.must_equal(1)
  end

  it "loads existing extensions - symbol" do
    pluginator = Pluginator.find("something", extends: :conversions)
    pluginator.public_methods.must_include(:class2string)
    pluginator.public_methods.must_include(:string2class)
    pluginator.public_methods.wont_include(:plugins_map)
  end
end
