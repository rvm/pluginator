module Pluginator
  class PluginatorError < RuntimeError
  end

  class MissingPlugin < PluginatorError
    def initialize(type, name, list)
      list = list.map{|e| "'#{e}'" }.join(", ")
      super("Can not find plugin '#{name}' in #{list} for type '#{type}'.")
    end
  end

  class MissingType < PluginatorError
    def initialize(type, list)
      list = list.map{|e| "'#{e}'" }.join(", ")
      super("Can not find type '#{type}' in #{list}.")
    end
  end
end
