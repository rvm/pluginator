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

require "pluginator/autodetect/finder"

module Pluginator
  class Autodetect

    # Categorize plugins
    # @see: Finder
    class FormattedFinder < Finder

      # Reformat plugin lists
      def initialize(force_prefix, group, force_type)
        super
        map_loaded_plugins
        map_gem_plugins
      end

    private

      def gem_has_method?(name)
        Gem.methods.map(&:to_sym).include?(name)
      end

      def map_loaded_plugins
        @loaded_plugins_path.map! do |_path, name, type|
          [name, type]
        end
      end

      def map_gem_plugins
        gem_specifications = find_gem_specifications
        @gem_plugins_paths.map! do |path, name, type|
          gemspec = gemspec_for_path(path, gem_specifications)
          [gemspec, path, name, type] if gemspec
        end.compact
      end

      def find_gem_specifications
        if
          gem_has_method?(:gemdeps) && Gem.gemdeps
        then
          # :nocov: only testable with using rubygems's gemdeps feature
          Gem.loaded_specs.values.to_a
          # :nocov:
        else
          specs = Gem::Specification._all.to_a
          specs = (Gem.loaded_specs.values.to_a + specs).uniq if gem_has_method?(:loaded_specs)
          specs
        end
      end

      def gemspec_for_path(path, specifications)
        gemspecs = gemspecs_for_path(path, specifications)
        case
          gemspecs.size
        when 0
          nil
        when 1
          gemspecs.first
        else
          find_latest_plugin_version(gemspecs, path)
        end
      end

      def gemspecs_for_path(path, specifications)
        specifications.reject do |spec|
          Dir.glob( File.join( spec.lib_dirs_glob, path ) ).empty?
        end
      end

      def find_latest_plugin_version(gemspecs, path)
        active_or_latest_gemspec(gemspecs_sorted_by_metadata_and_version(gemspecs, path))
      end

      # find active or latest gem in given set
      def active_or_latest_gemspec(specifications)
        specifications.find(&:activated) || specifications.last
      end

      def gemspecs_sorted_by_metadata_and_version(gemspecs, path)
        gemspecs.sort_by do |spec|
          [calculate_plugin_version(spec.metadata, path), spec.name, spec.version]
        end
      end

      def calculate_plugin_version(metadata, path)
        ( (metadata || {})[path] || "0" ).to_i
      end

    end
  end
end
