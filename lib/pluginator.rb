require_relative "pluginator/extendable_autodetect"
require_relative "pluginator/version"

module Pluginator
  def self.group(group, type: nil, extends: [])
    Pluginator::ExtendableAutodetect.new(group, type: type, extends: extends)
  end
end
