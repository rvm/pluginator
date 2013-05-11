require_relative "plugins_map"
require_relative "conversions"

module Pluginator::Extensions
  module FirstClass
    include PluginsMap
    include Conversions

    def first_class(type, klass)
      (plugins_map(type) || {})[string2class(klass)]
    end

    def first_class!(type, klass)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      klass = string2class(klass)
      plugins_map(type)[klass] or
        raise Pluginator::MissingPlugin.new(type, klass, plugins_map(type).keys)
    end
  end
end
