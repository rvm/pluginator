require_relative "plugins_map"
require_relative "conversions"

module Pluginator::Extensions
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
