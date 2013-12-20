require 'test_helper'
require 'pluginator/extendable_autodetect'

describe Pluginator::ExtendableAutodetect do
  it "loads existing extensions - array" do
    pluginator = Pluginator::ExtendableAutodetect.new("something", :extends => [:conversions])
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it "loads existing extensions - symbol" do
    pluginator = Pluginator::ExtendableAutodetect.new("something", :extends => :conversions)
    pluginator.public_methods.map(&:to_sym).must_include(:class2string)
    pluginator.public_methods.map(&:to_sym).must_include(:string2class)
    pluginator.public_methods.map(&:to_sym).wont_include(:plugins_map)
  end

  it "fails to load missing extension" do
    lambda {
      Pluginator::ExtendableAutodetect.new("something", :extends => [:missing_conversions])
    }.must_raise(Pluginator::MissingPlugin)
  end
end
