require "plugins/pluginator/extensions/plugins_map"

module Pluginator::Extensions
  # Extension to find first plugin that answers the question with true
  module FirstAsk

    include PluginsMap

    # Call a method on plugin and return first one that returns `true`.
    #
    # @param type [String] name of type to search for plugins
    # @param method_name [Symbol] name of the method to execute
    # @param params [Array] params to pass to the called method
    # @return The first plugin that method call returns true
    def first_ask(type, method_name, *params)
      @plugins[type] or return nil
      try_to_find(type, method_name, params)
    end

    # Call a method on plugin and return first one that returns `true`.
    # Behaves like `first_ask` but throws exceptions if can not find anything.
    def first_ask!(type, method_name, *params)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      try_to_find(type, method_name, params) or
      raise Pluginator::MissingPlugin.new(type, "first_ask: #{method_name}", plugins_map(type).keys)
    end

  private

    def try_to_find(type, method_name, params)
      @plugins[type].detect do |plugin|
        has_public_method?(plugin, method_name) &&
        plugin.send(method_name.to_sym, *params)
      end
    end

    # need to use this trick because of old rubies support
    def has_public_method?(plugin, method_name)
      plugin.public_methods.map(&:to_sym).include?(method_name.to_sym)
    end

  end
end
