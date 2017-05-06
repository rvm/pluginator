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

require "pluginator/errors"
require "pluginator/group"
require "pluginator/name_converter"

module Pluginator
  # Add autodetection capabilities to Group
  # @see Group
  class Autodetect < Group

    # Automatically load plugins for given group (and type)
    #
    # @param group   [String] name of the plugins group
    # @param options [Hash]   options to pass to creating Pluginator instance
    # @option type   [String] name of the plugin type
    def initialize(group, options = {})
      super(group)
      @force_type = options[:type]
      refresh
    end

    # Initiate another lookup for plugins
    # - does not clean the state
    # - does not resolve all gems, only the new ones
    #
    # Use it after gem list change, for example after `Gem.install("new_gem")`
    def refresh
      load_plugins(
        *detect_plugins(
          unique_parsed_paths(
            find_files
          )
        )
      )
    end

    # Return the forced type
    def type
      @plugins[@force_type] unless @force_type.nil?
    end

    private

    include NameConverter

    def find_files
      Gem.find_files(file_name_pattern(@group, @force_type), true)
    end

    def unique_parsed_paths(file_names)
      file_names.map do |file_name|
        split_file_name(file_name, @group)
      end.sort.uniq
    end

    def detect_plugins(parsed_paths)
      plugins_to_register = []
      plugins_to_activate = []
      plugins_to_load     = []
      loaded_plugins      = find_loaded_plugins
      available_gem_specs = gem_specifications
      parsed_paths.each do |path, name, type|
        if loaded_plugins.include?(path)
          plugins_to_register.push([name, type])
        elsif (gemspec = gemspec_for_path(path, available_gem_specs))
          plugins_to_activate.push([gemspec, path, name, type])
        else
          plugins_to_load.push([path, name, type])
        end
      end
      [ plugins_to_register, plugins_to_activate, plugins_to_load ]
    end

    def find_loaded_plugins
      $LOADED_FEATURES.map{ |file_name|
        split_file_name(file_name, @group)
      }.compact.map(&:first)
    end

    def gem_specifications
      if
        Gem.methods.map(&:to_sym).include?(:gemdeps) && Gem.gemdeps
      then
        # :nocov: only testable with using rubygems's gemdeps feature
        Gem.loaded_specs.values
        # :nocov:
      else
        specs = Gem::Specification._all
        if Gem.methods.map(&:to_sym).include?(:loaded_specs)
          specs = (Gem.loaded_specs.values + specs).uniq
        end
        specs
      end
    end

    def load_plugins(plugins_to_register, plugins_to_activate, plugins_to_load)
      plugins_to_register.each do |name, type|
        register_plugin(type, name2class(name))
      end
      plugins_to_load.each do |path, name, type|
        require path
        register_plugin(type,name2class(name))
      end
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
      specifications.group_by(&:name).map do |name, specifications|
        active_or_latest_gemspec(specifications.sort)
      end
    end

    # find active or latest gem in given set
    def active_or_latest_gemspec(specifications)
      specifications.find(&:activated) || specifications.last
    end

    def gemspec_for_path(path, specifications)
      gemspecs = specifications.reject do |spec|
        Dir.glob( File.join( spec.lib_dirs_glob, path ) ).empty?
      end
      case gemspecs.size
      when 0
        nil
      when 1
        gemspecs.first
      else
        find_latest_plugin_version(gemspecs, path)
      end
    end

    def find_latest_plugin_version(gemspecs, path)
      active_or_latest_gemspec(gemspecs_sorted_by_metadata_and_version(gemspecs, path))
    end

    def gemspecs_sorted_by_metadata_and_version(gemspecs, path)
      gemspecs.sort_by do |spec|
        [calculate_plugin_version(spec.metadata, path), spec.name, spec.version]
      end
    end

    def calculate_plugin_version(metadata, path)
      ((metadata||{})[path]||"0").to_i
    end

    # file_name, group => [ path, full_name, type ]
    def split_file_name(file_name, group)
      match = file_name.match(/.*\/(plugins\/(#{group}\/(.*)\/[^\/]*)\.rb)$/)
      match[1..3] if match
    end

    # group => pattern
    def file_name_pattern(group, type=nil)
      "plugins/#{group}/#{type || "**"}/*.rb"
    end

  end
end
