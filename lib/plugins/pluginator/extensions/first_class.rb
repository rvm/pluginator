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
  # Extension to find first plugin whose class matches the string
  module FirstClass

    include PluginsMap
    include Conversions

    # Find first plugin whose class matches the given name.
    #
    # @param type  [String] name of type to search for plugins
    # @param klass [Symbol|String] name of the searched class
    # @return      [Class] The first plugin that matches the klass
    def first_class(type, klass)
      (plugins_map(type) || {})[string2class(klass)]
    end

    # Find first plugin whose class matches the given name.
    # Behaves like `first_class` but throws exceptions if can not find anything.
    # @param type  [String] name of type to search for plugins
    # @param klass [Symbol|String] name of the searched class
    # @return      [Class] The first plugin that matches the klass
    # @raise [Pluginator::MissingPlugin] when can not find plugin
    def first_class!(type, klass)
      @plugins[type] or raise Pluginator::MissingType.new(type, @plugins.keys)
      klass = string2class(klass)
      plugins_map(type)[klass] or
        raise Pluginator::MissingPlugin.new(type, klass, plugins_map(type).keys)
    end
  end
end
