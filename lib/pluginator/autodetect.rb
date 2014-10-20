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
    # @param group [String] name of the plugins group
    # @option type [String] name of the plugin type
    def initialize(group, options = {})
      super(group)
      setup_autodetect(options[:type])
    end

    # Return the forced type
    def type
      @plugins[@force_type] unless @force_type.nil?
    end

  private

    include NameConverter

    def setup_autodetect(type)
      force_type(type)
      load_files(find_files)
    end

    def force_type(type)
      @force_type = type
    end

    def find_files
      Gem.find_files(file_name_pattern(@group, @force_type))
    end

    def load_files(file_names)
      unique_gemspec_paths(file_names).each do |gemspec, path, name, type|
        gemspec.activate
        load_plugin(path) and
        register_plugin(type, name2class(name))
      end
    end

    def unique_gemspec_paths(file_names)
      all = gemspec_and_paths(file_names)
      selected = active_or_latest_gems_matching(all.map(&:first))
      all.map do |gemspec, path, name, type|
        [gemspec, path, name, type] if selected.assoc(gemspec)
      end.compact
    end

    # filter active / latest gem versions
    def active_or_latest_gems_matching(all)
      all.group_by(&:name).map do |name, specifications|
        active_or_latest_gem(specifications)
      end
    end

    # find active or latest gem in given set
    def active_or_latest_gem(specifications)
      specifications.find(&:activated) or specifications.sort.last
    end

    def gemspec_and_paths(file_names)
      unique_parsed_paths(file_names).map do |path, name, type|
        gemspec = gemspec_for_path(path)
        [gemspec, path, name, type] if gemspec
      end.compact
    end

    def unique_parsed_paths(file_names)
      file_names.map do |file_name|
        split_file_name(file_name, @group)
      end.sort.uniq
    end

    def gemspec_for_path(path)
      gemspecs = Gem::Specification._all.reject do |spec|
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
      gemspecs  = gemspecs_sorted_by_metadata_and_version(gemspecs)
      last      = gemspecs.last
      return last if gemspecs.size == 1

      activated = gemspecs.find(&:activated?)
      best      = Gem::Specification.find_by_path(path)

      pick_best(activated, best, last)
    end

    def gemspecs_sorted_by_metadata_and_version(gemspecs)
      gemspecs.sort_by do |spec|
        [
          ((spec.metadata||{})[path]||0).to_i,
          spec.name,
          spec.version,
        ]
      end
    end

    def pick_best(activated, best, last)
      if
        (activated.nil? || last == activated) && !best.activated?
      then
        last
      else
        best
      end
    end

    def load_plugin(path)
      require path
      true
    end

  end
end
