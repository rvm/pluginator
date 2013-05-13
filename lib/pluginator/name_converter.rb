module Pluginator
  # a helper for handling name / file / class conversions
  module NameConverter
  private

    # file_name, group => [ path, full_name, type ]
    def split_file_name(file_name, group)
      file_name.match(/.*\/(plugins\/(#{group}\/(.*)\/[^\/]*)\.rb)$/)[1..3]
    end

    # group => pattern
    def file_name_pattern(group, type=nil)
      "plugins/#{group}/#{type || "**"}/*.rb"
    end

    # full_name => class
    def name2class(name)
      klass = Kernel
      name.to_s.split(/\//).map{ |part|
        part.capitalize.gsub(/_(.)/){ $1.upcase }
      }.each{|part|
        klass = klass.const_get( part )
      }
      klass
    end

  end
end
