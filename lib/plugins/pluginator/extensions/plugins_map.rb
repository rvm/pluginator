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

require "plugins/pluginator/extensions/conversions"

module Pluginator::Extensions
  # extend Pluginator with map of plugins: name => klass
  module PluginsMap
    include Conversions

    # provide extra map of plugins with symbolized names as keys
    #
    # @param type [String] name of type to generate the map for
    # @return [Hash] map of the names and plugin classes

    def plugins_map(type)
      @plugins_map ||= {}
      type = type.to_s
      @plugins_map[type] ||= Hash[
        @plugins[type].map do |plugin|
          [class2name(plugin), plugin]
        end
      ]
    end
  end
end
