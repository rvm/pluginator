class Pluginator
  attr_reader :plugins_name

  def initialize(plugins_name)
    @plugins = {}
    @plugins_name = plugins_name
    detect
  end

  def first_plugin type, method, *args
    result = nil
    name, plugin = all_by_type(type).detect do |name, plugin|
      result = plugin.send(method.to_sym, *args)
    end
    [ name, plugin, result ]
  end

  def all_by_type type
    @plugins[type.to_s]
  end
  alias :[] :all_by_type

  def types
    @plugins.keys
  end

# TODO do we need those???
  def all_plugins type, method, *args
    @plugins[type.to_s].select do |name,plugin|
      plugin.send(method.to_sym, *args)
    end
  end
  def first_plugin_by_parent parent_class
    @plugins.detect do |type, plugins|
      plugins.detect do |name, plugin|
        plugin < parent_class
      end
    end
  end
  def find_class_by_parent parent_class
    classes = []
    ObjectSpace.each_object(Class) do |klass|
      classes << klass if klass < parent_class
    end
    classes
  end

private

  def detect
    Gem.find_files("plugins/#{@plugins_name}/*/*.rb").each do |file_name|
# $stderr.puts "parsing #{file_name}"
      path, name, type = file_name.match(/.*\/(plugins\/(#{@plugins_name}\/(.*)\/[^\/]*)\.rb)$/)[1..3]
      load_plugin path, file_name
      register_plugin type, name
    end
  end

  def load_plugin path, file_name
    gemspec = Gem::Specification.find_by_path(path)
    gemspec.activate if gemspec && !gemspec.activated?
    require path
  end

  def register_plugin type, name
    type = type.to_s
    @plugins[type] ||= {}
    if @plugins[type][name].nil?
# $stderr.puts "loading #{name}"
      @plugins[type][name] = name2class(name)
    end
  end

  def name2class name
    klass = Kernel
    name.split(/\//).map{ |part|
      part.capitalize.gsub(/_(.)/){ $1.upcase }
    }.each{|part|
      klass = klass.const_get( part )
    }
    klass
  end

end
