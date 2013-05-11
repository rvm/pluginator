require_relative "plugins_map"
require_relative "conversions"

module Pluginator::Extensions
  module Matching
    include PluginsMap
    include Conversions

    def matching(type, list)
      list.map do |plugin|
        (plugins_map(type) || {})[string2class(plugin)]
      end
    end

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
