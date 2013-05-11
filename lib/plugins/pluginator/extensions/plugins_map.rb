module Pluginator::Extensions
  module PluginsMap
    def plugins_map( type )
      @plugins_map ||= {}
      type = type.to_s
      @plugins_map[type] ||= Hash[ @plugins[type].map{|plugin| [plugin.name.split('::').last, plugin] } ]
    end
  end
end
