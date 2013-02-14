#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.email = ["mpapis@gmail.com"]
  s.authors = ["Michal Papis"]
  s.name = "pluginator"
  s.version = "0.9.2"
  s.files = `git ls-files`.split("\n")
  s.required_ruby_version = ">= 1.9.2"
  s.add_development_dependency("simplecov")
  s.add_development_dependency("rake")
  s.add_development_dependency("minitest")
  # s.add_development_dependency("smf-gem")
  s.homepage = "https://github.com/mpapis/pluginator"
  s.summary = "Rubygems plugin system using Gem.find_files."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
