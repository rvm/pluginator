# Pluginator

Gem plugin system management, detects plugins using `Gem.find_file`.
Is only supposed with ruby 1.9.2+

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

example `plugins/rvm2/cli/echo.rb`:

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

## Loading plugins

Example:

```ruby
require 'pluginator'

rvm2plugins = Pluginator.new("rvm2")
plugin = rvm2plugins["cli"].first{ |plugin|
  plugin.question?('echo')
}
plugin.new.answer("Hello world")
```
