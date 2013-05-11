require 'test_helper'
require 'pluginator/name_converter'

class Converter
  extend Pluginator::NameConverter
end

describe Pluginator::NameConverter do
  describe "files" do
    it "extracts file name components" do
      Converter.send(:split_file_name, "/path/to/plugins/group1/type1/name1.rb", "group1").
        must_equal(["plugins/group1/type1/name1.rb", "group1/type1/name1", "type1"])
    end

    it "builds group pattern" do
      Converter.send(:file_name_pattern, "group2").must_equal("plugins/group2/**/*.rb")
    end

    it "builds group/<nil> pattern" do
      Converter.send(:file_name_pattern, "group2").must_equal("plugins/group2/**/*.rb")
    end

    it "builds group/type pattern" do
      Converter.send(:file_name_pattern, "group2", "type3").must_equal("plugins/group2/type3/*.rb")
    end
  end

  describe "classes" do
    it "builds class" do
      Converter.send(:name2class, "Converter").must_equal(Converter)
    end
  end
end
