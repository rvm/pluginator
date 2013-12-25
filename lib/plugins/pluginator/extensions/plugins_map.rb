require "plugins/pluginator/extensions/conversions"

module Pluginator::Extensions
  # extend Pluginator with map of plugins: name => klass
  module PluginsMap
    include Conversions

    # provide extra map of plugins with symbolized names as keys
    #
    # @param type [String] name of type to generate the map for
    # @return [Hash] map of the names and plugin classes
    def plugins_map( type )
      @plugins_map ||= {}
      type = type.to_s
      @plugins_map[type] ||= Hash[ @plugins[type].map{|plugin| [class2name(plugin), plugin] } ]
    end
  end
end
