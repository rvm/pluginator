# Pluginator

[![Gem Version](https://badge.fury.io/rb/pluginator.png)](http://rubygems.org/gems/pluginator)
[![Code Climate](https://codeclimate.com/github/rvm/pluginator.png)](https://codeclimate.com/github/rvm/pluginator)
[![Coverage Status](https://coveralls.io/repos/rvm/pluginator/badge.png)](https://coveralls.io/r/rvm/pluginator)
[![Build Status](https://travis-ci.org/rvm/pluginator.png)](https://travis-ci.org/rvm/pluginator)
[![Dependency Status](https://gemnasium.com/rvm/pluginator.png)](https://gemnasium.com/rvm/pluginator)
[![Inline docs](http://inch-ci.org/github/rvm/pluginator.png)](http://inch-ci.org/github/rvm/pluginator)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/rvm/pluginator/master/frames)
[![Github Code](http://img.shields.io/badge/github-code-blue.svg)](https://github.com/rvm/pluginator)

Gem plugin system management, detects plugins using `Gem.find_file`,
`$LOAD_PATH` and `$LOADED_FEATURES`.

It is only supposed to work with ruby 1.9.3+ (some tests fail on 1.9.2)

Pluginator tries to stay out of your way, you do not have to include or inherit anything.
Pluginator only finds and groups plugins, rest is up to you,
you decide what methods to define and how to find them.

## Defining plugins

create a gem with a path:

```ruby
lib/plugins/<group>/<type>/<name>.rb
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
plugins = Pluginator.find("<group>", type: "<type>", extends: %i[<extensions>])
plugins["<type>"] => Array of plugins
plugins.type      => Array of plugins for type defined with `type: "<type>"`
plugins.types     => Array of types
```

- `"<group>"` - Load plugins for given group.
- `type: "<type>"` - Load plugins only of given type, makes `type` method accessible.
- `extends: %i[<extensions>]` - Extend pluginator with given extensions.

## Extensions

Pluginator comes with few handful extensions.

### Class exist

Check if plugin with given class name exists.

```ruby
plugins = Pluginator.find("<group>", extends: %i[class_exist]})
plugins.class_exist?("<type>", "<name>") => true or false
```

### First ask

Call a method on plugin and return first one that returns `true`.

```ruby
plugins = Pluginator.find("<group>", extends: %i[first_ask])
plugins.first_ask( "<type>", "method_to_call", *params) => plugin or nil
plugins.first_ask!("<type>", "method_to_call", *params) => plugin or exception PluginatorError
```

### First class

Find first plugin that class matches the given name.

```ruby
plugins = Pluginator.find("<group>", extends: %i[first_class])
plugins.first_class( "<type>", "<name>") => plugin or nil
plugins.first_class!("<type>", "<name>") => plugin or exception PluginatorError
```

### Matching

Map array of names to available plugins.

```ruby
plugins = Pluginator.find("<group>", extends: %i[matching])
plugins.matching( "<type>", [<array_of_names>]) => [plugins] # nil for missing ones
plugins.matching!("<type>", [<array_of_names>]) => [plugins] or exception PluginatorError
```

### Your own ones

You can define your own extensions for `pluginator`, for example:

```shell
plugins/pluginator/extensions/first_one.rb
```

with:

```ruby
module Pluginator::Extensions
  class FirstOne
    def first_one(type)
      @plugins[type].first
    end
  end
end
```

And now you can use it:

```ruby
plugins = Pluginator.find("<group>", extends: %i[first_one])
plugins.first_one("<type>") => first_plugin # nil when none
```


## Exceptions

- `PluginatorError` - base error for all Pluginator errors
- `MissingPlugin`   - raised when plugin can not be found, generated by `*!` methods
- `MissingType`     - raised when type   can not be found, generated by `*!` methods

## Versioning plugins

In case plugin gets moved to other gem you can sdpecify which gem to
use for loading the plugin by specifying plugin version in gems gemspec
metadata:

```ruby
s.metadata = {
  "plugins/v2test/stats/max.rb" => "1"
}
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
require "pluginator"

rvm2plugins = Pluginator.find("rvm2")
plugin = rvm2plugins["cli"].first{ |plugin|
  plugin.question?("echo")
}
plugin.new.answer("Hello world")
```

Or using extensions:

```ruby
require "pluginator"

plugin = Pluginator.find("rvm2", extends: %i[first_ask]).first_ask("cli", &:question?, "echo")
plugin.new.answer("Hello world")
```

### Example 2 - hook plugins

`plugins/rvm2/hooks/after_install/show.rb`:

```ruby
class Rvm2::Hooks::AfterInstall::Show
  def self.execute name, path
    puts "Ruby #{name.inspect} was installed in #{path.inspect}."
  end
end
```

and using hooks:

```ruby
require "pluginator"

Pluginator.find("rvm2", type: "hooks/after_install").type.each{ |plugin|
  plugin.execute(name, path)
}
```

## Testing

```bash
NOEXEC_DISABLE=1 rake test
```

## License

Copyright 2013-2017 Michal Papis <mpapis@gmail.com>

pluginator is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

pluginator is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with pluginator.  If not, see <http://www.gnu.org/licenses/>.

For details on adding copyright visit:
https://www.gnu.org/licenses/gpl-howto.html
