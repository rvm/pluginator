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
      file_names.each do |file_name|
        path, name, type = split_file_name(file_name, @group)
        load_plugin(path) and
        register_plugin(type, name2class(name))
      end
    end

    def load_plugin(path)
      gemspec = Gem::Specification.find_by_path(path)
      if
        gemspec
      then
        activated =
        Gem::Specification.find do |spec|
          spec.name == gemspec.name && spec.activated?
        end
        gemspec.activate if !gemspec.activated? && activated.nil?
        if
          activated.nil? || activated == gemspec
        then
          require path
          true
        else
          nil
        end
      end
    end

  end
end
