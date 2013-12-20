require 'test_helper'
require 'plugins/pluginator/extensions/conversions'

class ConversionsTester
  extend Pluginator::Extensions::Conversions
end

describe Pluginator::Extensions::Conversions do
  it "class2string" do
    ConversionsTester.class2string('SomethingLong').must_match('something_long')
  end
  it "string2class" do
    ConversionsTester.string2class('something_long').must_match('SomethingLong')
  end
end
