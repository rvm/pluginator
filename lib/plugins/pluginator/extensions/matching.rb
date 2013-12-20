require "plugins/pluginator/extensions/plugins_map"
require "plugins/pluginator/extensions/conversions"

module Pluginator::Extensions
  # Extension to select plugins that class name matches the list of string
  module Matching
    include PluginsMap
    include Conversions

    # Map array of names to available plugins.
    #
    # @param type [String] name of type to search for plugins
    # @param list [Array] list of plugin names to load
    # @return [Array] list of loaded plugins
    def matching(type, list)
      list.map do |plugin|
        (plugins_map(type) || {})[string2class(plugin)]
      end
    end

    # Map array of names to available plugins.
    # Behaves like `matching` but throws exceptions if can not find anything.
    def matching!(type, list)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      list.map do |plugin|
        plugin = string2class(plugin)
        plugins_map(type)[plugin] or
          raise Pluginator::MissingPlugin.new(type, plugin, plugins_map(type).keys)
      end
    end
  end
end
