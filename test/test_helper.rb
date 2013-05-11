require 'simplecov'
SimpleCov.command_name "Unit Tests"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/demo/"
end

require 'minitest/autorun'
