require_relative "plugins_map"

module Pluginator::Extensions
  module FirstAsk
    include PluginsMap

    # Call a method on plugin and return first one that returns `true`.
    #
    # @param type [String] name of type to search for plugins
    # @param method_name [Symbol] name of the method to execute
    # @param *params [Array] params to pass to the called method
    # @return The first plugin that method call returns true
    def first_ask(type, method_name, *params)
      @plugins[type] or return nil
      @plugins[type].detect do |plugin|
        plugin.public_send(method_name.to_sym, *params)
      end
    end

    # Call a method on plugin and return first one that returns `true`.
    # Behaves like `first_ask` but throws exceptions if can not find anything.
    def first_ask!(type, method_name, *params)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      @plugins[type].detect do |plugin|
        plugin.public_send(method_name, *params)
      end or
        raise Pluginator::MissingPlugin.new(type, "first_ask: #{method_name}", plugins_map(type).keys)
    end

  end
end
