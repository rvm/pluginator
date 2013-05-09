require 'minitest/autorun'
require 'pluginator/name_converter'

class Converter
  extend Pluginator::NameConverter
end

describe Pluginator::NameConverter do
  describe "files" do
    it "extracts file name components" do
      Converter.split_file_name("/path/to/plugins/group1/type1/name1.rb", "group1").
        must_equal(["plugins/group1/type1/name1.rb", "group1/type1/name1", "type1"])
    end
    it "builds group pattern" do
      Converter.file_name_pattern("group2").must_equal("plugins/group2/**/*.rb")
    end
  end

  describe "classes" do
    it "builds class" do
      Converter.name2class("Converter").must_equal(Converter)
    end
  end
end
