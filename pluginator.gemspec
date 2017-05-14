#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# stub: PLUGINATOR ruby lib

=begin
Copyright 2013-2017
- Michal Papis <mpapis@gmail.com>
- Jordon Bedwell <envygeeks@gmail.com>

This file is part of pluginator.

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
=end

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pluginator/version"

Gem::Specification.new do |s|
  s.email   = ["mpapis@gmail.com", "envygeeks@gmail.com", "mose@mose.com", "johnogara@gmail.com"]
  s.authors = ["Michal Papis",     "Jordon Bedwell",      "Mose",          "John O'Gara"        ]
  s.name    = "pluginator"
  s.version = Pluginator::VERSION
  s.license = "LGPL v3"
  s.files   = Dir["lib/**/*.rb", "*.md", "COPYING*"]
  s.required_ruby_version = ">= 1.8.7"
  s.add_development_dependency("rake")
  s.add_development_dependency("rubocop")
  s.add_development_dependency("minitest")
  s.add_development_dependency("minitest-reporters")
  # s.add_development_dependency("smf-gem")
  s.homepage = "https://github.com/rvm/pluginator"
  s.summary = "Rubygems plugin system using Gem.find_files, $LOAD_PATH and $LOADED_FEATURES."
end
