=begin
Copyright 2013 Michal Papis <mpapis@gmail.com>

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

source "https://rubygems.org"

#ruby=2.0.0

gemspec

group :development do
  # statistics only on MRI 2.0 - avoid problems on older rubies
  gem "redcarpet",      :platforms => [:mri_20]
  gem "simplecov",      :platforms => [:mri_20]
  gem "coveralls",      :platforms => [:mri_20]
  gem "guard",          :platforms => [:mri_20]
  gem "guard-minitest", :platforms => [:mri_20]
  gem "guard-yard",     :platforms => [:mri_20]
end

# when running tests in bundler
if
  [ $0, $* ].flatten.first{|e| e=~/rake/}
then
  # make sure test gems path is used
  Gem.path << File.expand_path("../test/gems", __FILE__)
  Gem.refresh

  # and add test gems to bundler
  gem "fake-gem-name-a"
end
