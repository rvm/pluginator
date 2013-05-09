# Pluginator

[![Code Climate](https://codeclimate.com/github/rvm/pluginator.png)](https://codeclimate.com/github/rvm/pluginator)
[![Build Status](https://travis-ci.org/rvm/pluginator.png?branch=master)](https://travis-ci.org/rvm/pluginator)
[![Dependency Status](https://gemnasium.com/rvm/pluginator.png)](https://gemnasium.com/rvm/pluginator)

Gem plugin system management, detects plugins using `Gem.find_file`.
Is only supposed with ruby 1.9.3+

Pluginator tries to stay out of your way, you do not have to include or inherit anything.
Pluginator only finds and groups plugins, rest is up to you,
you decide what methods to define and how to find them.

## Defining plugins

crate a gem with a path:

```ruby
plugins/<group>/<type>/<name>.rb
```

with a class inside:

```ruby
<group>::<type>::<name>
```

where `<type>` can be nested

## Loading plugins

```ruby
rvm2plugins = Pluginator::Autodetect.new("<group>")
type_plugins = rvm2plugins["<type>"]
types = rvm2plugins.types
```

## Loading plugins of single type

```ruby
rvm2plugins = Pluginator::Autodetect.new("<group>", "<type>")
type_plugins = rvm2plugins["<type>"]
rvm2plugins.types => ["<type>"]
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

rvm2plugins = Pluginator::Autodetect.new("rvm2")
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

rvm2plugins = Pluginator::Autodetect.new("rvm2")
plugin = rvm2plugins["hooks/after_install"].each{ |plugin|
  plugin.execute(name, path)
}
```
