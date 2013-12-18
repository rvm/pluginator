require_relative "pluginator/extendable_autodetect"
require_relative "pluginator/version"

# A simple plugin system based on Gem.find_files
module Pluginator
  # Find plugins for the given group
  #
  # @param group [String] name of plugins group
  # @option type [String] name of type to load
  # @option extend [Array of/or Symbol] list of extension to extend into pluginator instance
  # @return instance of Pluginator
  def self.find(group, options = {})
    Pluginator::ExtendableAutodetect.new(group, options)
  end
end
