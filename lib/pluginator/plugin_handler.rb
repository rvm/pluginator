require 'pluginator'

class Pluginator
  class UnknownPlugin < StandardError
    def initialize(plugin_type, handler)
      super "Unknown #{plugin_type}: #{handler}"
    end
  end

  module ExtraNames
    def last_name
      self.name.split(/::/).last
    end
    def last_name_to_sym
      class2file(last_name).to_sym
    end
    def first_name
      self.name.split(/::/).first
    end
    def first_name_to_sym
      class2file(first_name).to_sym
    end
    def class2file(klass)
      klass.gsub(/([A-Z])/){|x| "_#{x.downcase}"}[1..-1]
    end
  end

  class PluginHandler
    extend ExtraNames

    class Abstract
      extend ExtraNames
      def self.handles
        last_name_to_sym
      end
    end

    class << self
      attr_accessor :plugin_prefix
      attr_accessor :plugin_type
    end

    def self.first(handler)
      result = plugins[@plugin_type].detect{ |_,plugin| plugin.handles == handler }
      result = result.last unless result.nil?
      result
    end

    def self.first!(handler)
      found = first(handler)
      raise UnknownPlugin.new(@plugin_type, handler) if found.nil?
      found
    end

    def self.register_class(klass)
      plugins.register_plugin_class(@plugin_type, klass)
    end

    def self.plugins
      @plugin_prefix ||= first_name_to_sym
      @plugin_type   ||= last_name_to_sym
      @plugins       ||= Pluginator.new(@plugin_prefix)
    end

    def self.extend_abstract(&block)
      self.const_get(:Abstract).class_eval(&block)
    end
  end
end
