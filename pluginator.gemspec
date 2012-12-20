#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pluginator"
  s.version = "0.9.0"
  s.authors = ["Michal Papis"]
  s.email = ["mpapis@gmail.com"]
  s.homepage = "https://github.com/mpapis/pluginator"
  s.summary = %q{Rubygesm plugin system using Gem.find_files.}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.required_ruby_version = '>= 1.9.2'

  #s.add_development_dependency "smf-gem"
end
