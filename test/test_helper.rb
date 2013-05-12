require "coveralls"
require "simplecov"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
]

Coveralls.noisy = true
SimpleCov.command_name "Unit Tests"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/demo/"
end

require 'minitest/autorun'
