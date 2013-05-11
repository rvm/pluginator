module Pluginator::Extensions
  module Conversions
    def class2string( klass )
      klass.to_s.gsub(/([A-Z])/m){|match| "_#{$1.downcase}" }[1..-1]
    end
    def string2class( str )
      str.to_s.capitalize.gsub(/_(.)/){ $1.upcase }
    end
  end
end
