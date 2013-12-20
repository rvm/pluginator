require "plugins/pluginator/extensions/plugins_map"
require "plugins/pluginator/extensions/conversions"

module Pluginator::Extensions
  # Extension to find first plugin that class matches the string
  module FirstClass

    include PluginsMap
    include Conversions

    # Find first plugin that clas matches the given name.
    #
    # @param type [String] name of type to search for plugins
    # @param klass [Symbol or String] name of the searched class
    # @return The first plugin that matches the klass
    def first_class(type, klass)
      (plugins_map(type) || {})[string2class(klass)]
    end

    # Find first plugin that clas matches the given name.
    # Behaves like `first_class` but throws exceptions if can not find anything.
    def first_class!(type, klass)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      klass = string2class(klass)
      plugins_map(type)[klass] or
        raise Pluginator::MissingPlugin.new(type, klass, plugins_map(type).keys)
    end
  end
end
