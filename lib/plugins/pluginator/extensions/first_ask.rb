require_relative "plugins_map"

module Pluginator::Extensions
  module FirstAsk
    include PluginsMap

    def first_ask(type, method_name, *params)
      @plugins[type] or return nil
      @plugins[type].detect do |plugin|
        plugin.public_send(method_name, *params)
      end
    end

    def first_ask!(type, method_name, *params)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      @plugins[type].detect do |plugin|
        plugin.public_send(method_name, *params)
      end or
        raise Pluginator::MissingPlugin.new(type, "first_ask: #{method_name}", plugins_map(type).keys)
    end

  end
end
