require "coveralls"
require "simplecov"

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  command_name "Unit Tests"
  add_filter "/test/"
  add_filter "/demo/"
end

Coveralls.noisy = true unless ENV['CI']

require 'minitest/autorun'
require 'minitest/unit'
