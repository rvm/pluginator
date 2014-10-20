=begin
Copyright 2013 Michal Papis <mpapis@gmail.com>

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
require "plugins/pluginator/extensions/conversions"

module Pluginator::Extensions
  # Extension to select plugins that class name matches the list of string
  module Matching
    include PluginsMap
    include Conversions

    # Map array of names to available plugins.
    #
    # @param type [String] name of type to search for plugins
    # @param list [Array]  list of plugin names to load
    # @return     [Array]  list of loaded plugins
    def matching(type, list)
      list.map do |plugin|
        (plugins_map(type) || {})[string2class(plugin)]
      end
    end

    # Map array of names to available plugins.
    # Behaves like `matching` but throws exceptions if can not find anything.
    # @param type [String] name of type to search for plugins
    # @param list [Array]  list of plugin names to load
    # @return     [Array]  list of loaded plugins
    # @raise [Pluginator::MissingPlugin] when can not find plugin
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
