=begin
Copyright 2017 Michal Papis <mpapis@gmail.com>

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
  class Autodetect

    # Find plugins
    class Finder

      attr_reader :loaded_plugins_path, :load_path_plugins_paths, :gem_plugins_paths

      # Automatically load plugins for given group (and type)
      #
      # @param group      [String] name of the plugins group
      # @param force_type [String] name of the plugin type if forcing
      def initialize(group, force_type)
        @group      = group
        @force_type = force_type
        @pattern    = file_name_pattern(@group, @force_type)
        find_paths
      end

    private

      # group => pattern
      def file_name_pattern(group, type=nil)
        "plugins/#{group}/#{type || "**"}/*.rb"
      end

      def find_paths
        @loaded_plugins_path     =  find_loaded_plugins
        @load_path_plugins_paths =  find_load_path_plugins - @loaded_plugins_path
        @gem_plugins_paths       =  find_gem_plugins       - @load_path_plugins_paths - @loaded_plugins_path
      end

      def find_loaded_plugins
        split_file_names(
          $LOADED_FEATURES
        ).compact
      end

      def find_load_path_plugins
        split_file_names(
          Gem.find_files_from_load_path(@pattern)
        )
      end

      def find_gem_plugins
        split_file_names(
          Gem.find_files(@pattern, false)
        )
      end

      def split_file_names(file_names)
        file_names.map do |file_name|
          split_file_name(file_name, @group, @force_type)
        end
      end

      # file_name, group, type => [ path, full_name, type ]
      def split_file_name(file_name, group, type=nil)
        type ||= ".*"
        match = file_name.match(%r{.*/(plugins/(#{group}/(#{type})/[^/]*)\.rb)$})
        match[1..3] if match
      end

    end
  end
end
