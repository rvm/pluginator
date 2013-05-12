module Pluginator::Extensions
  module PluginsMap
    # provide extra map of plugins with symbolized names as keys
    #
    # @param type [String] name of type to generate the map for
    # @return [Hash] map of the names and plugin classes
    def plugins_map( type )
      @plugins_map ||= {}
      type = type.to_s
      @plugins_map[type] ||= Hash[ @plugins[type].map{|plugin| [plugin.name.split('::').last, plugin] } ]
    end
  end
end
