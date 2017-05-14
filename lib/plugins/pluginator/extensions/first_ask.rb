=begin
Copyright 2013-2017 Michal Papis <mpapis@gmail.com>

This file is part of pluginator.

pluginator is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

pluginator is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with pluginator.  If not, see <http://www.gnu.org/licenses/>.
=end

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
    # @return [Class] The first plugin that method call returns true
    def first_ask(type, method_name, *params)
      @plugins[type] or return nil
      try_to_find(type, method_name, params)
    end

    # Call a method on plugin and return first one that returns `true`.
    # Behaves like `first_ask` but throws exceptions if can not find anything.
    # @param type [String] name of type to search for plugins
    # @param method_name [Symbol] name of the method to execute
    # @param params [Array] params to pass to the called method
    # @return [Class] The first plugin that method call returns true
    # @raise [Pluginator::MissingPlugin] when can not find plugin
    def first_ask!(type, method_name, *params)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      try_to_find(type, method_name, params) or
      raise Pluginator::MissingPlugin.new(type, "first_ask: #{method_name}", plugins_map(type).keys)
    end

  private

    def try_to_find(type, method_name, params)
      @plugins[type].detect do |plugin|
        has_public_method?(plugin, method_name) and
        plugin.send(method_name.to_sym, *params)
      end
    end

    # need to use this trick because of old rubies support
    def has_public_method?(plugin, method_name)
      plugin.public_methods.map(&:to_sym).include?(method_name.to_sym)
    end

  end
end
