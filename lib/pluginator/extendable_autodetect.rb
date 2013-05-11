require_relative "autodetect"

module Pluginator
  class ExtendableAutodetect < Autodetect

    def initialize(group, type: nil, extends: [])
      super(group, type: type)
      extend_plugins(extends)
    end

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
      pluginator_plugins.filter!("extensions", flatten_and_stringify(extends))
    end

  end
end
