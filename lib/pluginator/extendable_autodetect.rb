require_relative "autodetect"

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
    # @param group [String] name of the plugins group
    # @option type [String] name of type to load
    # @option extend [Array of/or Symbol] list of extension to extend into pluginator instance
    def initialize(group, type: nil, extends: [])
      super(group, type: type)
      extend_plugins(extends)
    end

    # Extend pluginator instance with given extensions
    #
    # @param extends list of extension to extend into pluginator instance
    def extend_plugins(extends)
      extensions_matching(extends).each do |plugin|
        extend plugin
      end
    end

  private

    def flatten_and_stringify(extends)
      extends = [extends].flatten.map(&:to_s)
      extends
    end

    def pluginator_plugins
      @pluginator_plugins ||= begin
        plugins = Pluginator::Autodetect.new("pluginator")
        plugins.extend(Pluginator::Extensions::Matching)
        plugins
      end
    end

    def extensions_matching(extends)
      pluginator_plugins.matching!("extensions", flatten_and_stringify(extends))
    end

  end
end
