module Pluginator::Extensions
  # a placeholder for methods to convert strings
  module Conversions

    # converts class name to a file name
    def class2string( klass )
      klass.to_s.gsub(/([A-Z])/m){|match| "_#{$1.downcase}" }[1..-1]
    end

    # converts file name to a class name
    def string2class( str )
      str.to_s.capitalize.gsub(/_(.)/){ $1.upcase }
    end

  end
end
