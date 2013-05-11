# Pluginator

[![Code Climate](https://codeclimate.com/github/rvm/pluginator.png)](https://codeclimate.com/github/rvm/pluginator)
[![Build Status](https://travis-ci.org/rvm/pluginator.png?branch=master)](https://travis-ci.org/rvm/pluginator)
[![Dependency Status](https://gemnasium.com/rvm/pluginator.png)](https://gemnasium.com/rvm/pluginator)

Gem plugin system management, detects plugins using `Gem.find_file`.
Is only supposed with ruby 2.0.0+ (requires keyword arguments)

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
rvm2plugins = Pluginator.find("<group>")
type_plugins = rvm2plugins["<type>"]
types = rvm2plugins.types
```

## Usage

```ruby
Pluginator.find("<group>") => Pluginator object
plugins = Pluginator.find("<group>", type: "<type>", extends: %i{<extensions>})
plugins["<type>"] => Array of plugins
plugins.type      => Array of plugins for type defined with `type: "<type>"`
plugins.types     => Array of types
```

- `"<group>"` - Load plugins for given group.
- `type: "<type>"` - Load plugins only of given type, makes `type` method accessible.
- `extends: %i{<extensions>}` - Extend pluginator with given extensions.

## Extensions

Pluginator comes with few handful extensions.

### First ask

Call a method on plugin and return first one that returns `true`.

```ruby
plugins = Pluginator.find("<group>", extends: %i{first_ask})
plugins.first_ask( "<type>", "method_to_call", *params) => plugin or nil
plugins.first_ask!("<type>", "method_to_call", *params) => plugin or exception PluginatorError
```

### Matching

Map array of names to available plugins.

```ruby
plugins = Pluginator.find("<group>", extends: %i{matching})
plugins.matching( "<type>", [<array_of_names>]) => [plugins] # nil for missing ones
plugins.matching!("<type>", [<array_of_names>]) => [plugins] or exception PluginatorError
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

rvm2plugins = Pluginator.find("rvm2")
plugin = rvm2plugins["cli"].first{ |plugin|
  plugin.question?('echo')
}
plugin.new.answer("Hello world")
```

Or using extensions:

```ruby
require 'pluginator'

plugin = Pluginator.find("rvm2", extends: %i{first_ask}).first_ask("cli", &:question?, 'echo')
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

Pluginator.find("rvm2", type: "hooks/after_install").type.each{ |plugin|
  plugin.execute(name, path)
}
```
