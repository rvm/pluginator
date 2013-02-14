# Pluginator

Gem plugin system management, detects plugins using `Gem.find_file`.
Is only supposed with ruby 1.9.2+

Pluginator tries to stay out of your way, you do not have to include or inherit anything.
Pluginator only finds and groups plugins, rest is up to you,
you decide what methods to define and how to find them.

## Defining plugins

crate a gem with a path:

```ruby
plugins/<prefix>/<type>/<name>.rb
```

with a class inside:

```ruby
<prefix>::<type>::<name>
```

where `<type>` can be nested

## Loading plugins

```ruby
rvm2plugins = Pluginator.new("<prefix>")
type_plugins = rvm2plugins["<type>"]
types = rvm2plugins.types
```

## Examples

### Example 1 - task plugins

`plugins/rvm2/cli/echo.rb`:

```ruby
class Rvm2::Cli::Echo
  def self.question? command
    command == "echo"
  end
  def answer param
    puts param
  end
end
```

where `question?` and `answer` are user defined methods

Now the plugin can be used:

```ruby
require 'pluginator'

rvm2plugins = Pluginator.new("rvm2")
plugin = rvm2plugins["cli"].first{ |plugin|
  plugin.question?('echo')
}
plugin.new.answer("Hello world")
```

### Example 2 - hook plugins

`plugins/rvm2/hooks/after_install/show.rb`:

```ruby
class Rvm2::Hooks::AfterInstall::Show
  def self.execute name, path
    puts "Ruby '#{name}' was installed in '#{path}'."
  end
end
```

and using hooks:

```ruby
require 'pluginator'

rvm2plugins = Pluginator.new("rvm2")
plugin = rvm2plugins["hooks/after_install"].each{ |plugin|
  plugin.execute(name, path)
}
```

## Example 3 - plugin handler

`lib/plugins/foo/bar/out.rb`:

```ruby
class Foo::Bar::Out < Foo::Bar::Abstract
  def show(*args)
    puts "OUTPUT: #{args*", "}"
  end
end
```

`lib/plugins/foo/bar/err.rb`:

```ruby
class Foo::Bar::Err < Foo::Bar::Abstract
  def show(*args)
    $stderr.puts "ERROR: #{args*", "}"
  end
end
```

`lib/foo/bar.rb`:

```ruby
require 'pluginator/plugin_handler'

class Foo
  class Bar < Pluginator::PluginHandler
    def self.show(type, *args)
      first!(type).show(*args)
    end
  end
end
```

And using is as easy:

```ruby
Foo::Bar.show(:out, "goes to stdout") => OUTPUT: goes to stdout
Foo::Bar.show(:err, "goes to stderr") => ERROR: goes to stderr
```
