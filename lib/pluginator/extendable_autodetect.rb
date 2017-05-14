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

require "pluginator/autodetect"

module Pluginator
  # Container for all Pluginator extensions,
  # they are loaded in `ExtendableAutodetect`
  # @see ExtendableAutodetect#extend_plugins
  module Extensions
  end

  # Add extendability to Atudetect / Group
  # @see Autodetect
  # @see Group
  class ExtendableAutodetect < Autodetect

    # Automatically load plugins for given group (and type)
    # Extend instance with extensions if given.
    #
    # @param group    [String] name of the plugins group
    # @param options  [Hash]   options to pass to creating Pluginator instance
    # @option type    [String] name of type to load
    # @option extends [Array<Symbol>|Symbol] list of extension to extend into pluginator instance
    def initialize(group, options={})
      super(group, options)
      extend_plugins(options[:extends] || [])
    end

    # Extend pluginator instance with given extensions
    #
    # @param extends [Array<Symbol>|Symbol] list of extension to extend into pluginator instance
    def extend_plugins(extends)
      extensions_matching(extends).each do |plugin|
        extend plugin
      end
    end

  private

    def pluginator_plugins
      @pluginator_plugins ||= begin
        plugins = Pluginator::Autodetect.new("pluginator")
        plugins.extend(Pluginator::Extensions::Matching)
        plugins
      end
    end

    def extensions_matching(extends)
      extends = [extends].flatten.map(&:to_s)
      pluginator_plugins.matching!("extensions", extends)
    end

  end
end
