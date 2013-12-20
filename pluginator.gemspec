#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require File.expand_path("../lib/pluginator/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.email = ["mpapis@gmail.com"]
  s.authors = ["Michal Papis"]
  s.name = "pluginator"
  s.version = Pluginator::VERSION
  s.files = `git ls-files`.split("\n")
  s.required_ruby_version = ">= 1.8.7"
  s.add_development_dependency("rake")
  s.add_development_dependency("minitest")
  # s.add_development_dependency("smf-gem")
  s.homepage = "https://github.com/rvm/pluginator"
  s.summary = "Rubygems plugin system using Gem.find_files."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
