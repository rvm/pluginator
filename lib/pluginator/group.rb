module Pluginator
  # Initial data for pluginator, includes group name and plugins
  class Group
    # Group name used for plugins
    attr_reader :group

    # @param group [String] name of the plugins group
    def initialize(group)
      setup_group(group)
    end

    # @param [String] type of plugins to select
    # @return [Array] list of plugins for type
    def [](type)
      @plugins[type.to_s]
    end

    # @return [Array] list of plugin types loaded
    def types
      @plugins.keys
    end

    # Register a new plugin, can be used to load custom plugins
    #
    # @param type [String] type for the klass
    # @param klass [Class] klass of the plugin to add
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
