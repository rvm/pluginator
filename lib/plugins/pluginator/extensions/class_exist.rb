require_relative "plugins_map"
require_relative "conversions"

module Pluginator::Extensions
  # Extension to check if plugin for given class name exist
  module ClassExist

    include PluginsMap
    include Conversions

    # Check if plugin for given name exists.
    #
    # @param type [String] name of type to search for plugins
    # @param klass [Symbol or String] name of the searched class
    # @return [Boolean] klass exists
    def class_exist?(type, klass)
      !!(plugins_map(type) || {})[string2class(klass)]
    end
  end
end
