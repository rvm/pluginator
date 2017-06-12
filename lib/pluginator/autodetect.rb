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

require "pluginator/errors"
require "pluginator/group"
require "pluginator/name_converter"

module Pluginator
  class Autodetect < Group
  end
end

require "pluginator/autodetect/formatted_finder"

module Pluginator
  # Add autodetection capabilities to Group
  # @see Group, FormattedFinder
  class Autodetect

    # Automatically load plugins for given group (and type)
    #
    # @param group   [String] name of the plugins group
    # @param options [Hash]   options to pass to creating Pluginator instance
    # @option type   [String] name of the plugin type
    # @option prefix [String] a prefix for finding plugins if forcing,
    #                         by default only `/lib` is checked,
    #                         regexp notation is allowed, for example `/(lib|local_lib)`

    def initialize(group, options={})
      super(group)
      @force_prefix = options[:prefix]
      @force_type   = options[:type]
      refresh
    end

    # Initiate another lookup for plugins
    # - does not clean the state
    # - does not resolve all gems, only the new ones
    #
    # Use it after gem list change, for example after `Gem.install("new_gem")`
    def refresh
      plugin_lists = FormattedFinder.new(@force_prefix, @group, @force_type)
      register_plugins(plugin_lists.loaded_plugins_path)
      load_plugins(plugin_lists.load_path_plugins_paths)
      activate_plugins(plugin_lists.gem_plugins_paths)
    end

    # Return the forced type
    def type
      @plugins[@force_type] unless @force_type.nil?
    end

  private

    include NameConverter

    def register_plugins(plugins_to_register)
      plugins_to_register.each do |name, type|
        register_plugin(type, name2class(name))
      end
    end

    def load_plugins(plugins_to_load)
      plugins_to_load.each do |path, name, type|
        require path
        register_plugin(type, name2class(name))
      end
    end

    def activate_plugins(plugins_to_activate)
      selected = active_or_latest_gems_matching(plugins_to_activate.map(&:first).compact)
      plugins_to_activate.each do |gemspec, path, name, type|
        next unless selected.include?(gemspec)
        gemspec.activate
        require path
        register_plugin(type, name2class(name))
      end
    end

    # filter active / latest gem versions
    def active_or_latest_gems_matching(specifications)
      specifications.group_by(&:name).map do |_name, plugin_specifications|
        active_or_latest_gemspec(plugin_specifications.sort)
      end
    end

    # find active or latest gem in given set
    def active_or_latest_gemspec(specifications)
      specifications.find(&:activated) || specifications.last
    end

  end
end
