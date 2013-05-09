require 'minitest/autorun'
require 'pluginator/group'

describe Pluginator::Group do
  it "has name" do
    Pluginator::Group.new("something").group.must_equal("something")
  end

  describe "plugins list" do
    before do
      @group = Pluginator::Group.new("something")
    end

    it "adds type" do
      @group.register_plugin("type1", nil)
      @group.types.must_include("type1")
      @group.types.wont_include("type2")
    end

    it "adds plugin" do
      @group.register_plugin("type1", "test1")
      @group["type1"].must_include("test1")
      @group["type1"].wont_include("test2")
    end
  end
end
