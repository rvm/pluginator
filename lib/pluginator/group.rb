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

module Pluginator
  # Initial data for pluginator, includes group name and plugins
  class Group
    # Group name used for plugins
    attr_reader :group

    # sets up new instance and initial configuration
    # @param group [String] name of the plugins group
    def initialize(group)
      setup_group(group)
    end

    # @param [String] type of plugins to select
    # @return [Array] list of plugins for type
    def [](type)
      @plugins[type.to_s]
    end

    # @return [Array] list of plugin types loaded
    def types
      @plugins.keys
    end

    # Register a new plugin, can be used to load custom plugins
    #
    # @param type [String] type for the klass
    # @param klass [Class] klass of the plugin to add
    def register_plugin(type, klass)
      type = type.to_s
      @plugins[type] ||= []
      @plugins[type].push(klass) unless @plugins[type].include?(klass)
    end

  private

    def setup_group(group)
      @plugins = {}
      @group = group
    end
  end
end
