# -*- encoding: utf-8 -*-
# stub: fake-gem-name-v1b 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fake-gem-name-v1b"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michal Papis"]
  s.date = "2014-09-21"
  s.description = "Do nothing"
  s.email = ["mpapis@gmail.com"]
  s.files = Dir["../../gems/#{s.name}-#{s.version}/lib/**/*.rb"]
  s.homepage = "https://rvm.io"
  s.licenses = ["LGPL v3"]
  s.rubygems_version = "2.2.2"
  s.summary = "Do Nothing"
  s.metadata = {
    "plugins/v1test/stats/max.rb" => "1"
  }

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version
end
