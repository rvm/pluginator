module Pluginator
  class PluginatorError < RuntimeError
  private
    def list_to_s(list)
      list.map{|e| "'#{e}'" }.join(", ")
    end
  end

  class MissingPlugin < PluginatorError
    def initialize(type, name, list)
      super("Can not find plugin '#{name}' in #{list_to_s(list)} for type '#{type}'.")
    end
  end

  class MissingType < PluginatorError
    def initialize(type, list)
      super("Can not find type '#{type}' in #{list_to_s(list)}.")
    end
  end
end
