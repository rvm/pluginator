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
  # Extension to check if plugin for given class name exist
  module ClassExist

    include PluginsMap
    include Conversions

    # Check if plugin for given name exists.
    #
    # @param type [String] name of type to search for plugins
    # @param klass [Symbol or String] name of the searched class
    # @return [Boolean] klass exists
    def class_exist?(type, klass)
      !!(plugins_map(type) || {})[string2class(klass)]
    end
  end
end
