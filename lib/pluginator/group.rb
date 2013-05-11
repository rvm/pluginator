module Pluginator
  class Group
    attr_reader :group

    def initialize(group)
      setup_group(group)
    end

    def [](type)
      @plugins[type.to_s]
    end

    def types
      @plugins.keys
    end

    def register_plugin(type, klass)
      type = type.to_s
      @plugins[type] ||= []
      @plugins[type].push(klass)
    end

  private

    def setup_group(group)
      @plugins = {}
      @group = group
    end
  end
end
