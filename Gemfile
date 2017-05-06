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

#ruby=2.4.1

gemspec

group :development do
  # statistics only on MRI 2.4 - avoid problems on older rubies
  gem "redcarpet",      :platforms => [:mri_24]
  gem "simplecov",      :platforms => [:mri_24]
  gem "coveralls",      :platforms => [:mri_24]
  gem "guard",          :platforms => [:mri_24]
  gem "guard-minitest", :platforms => [:mri_24]
  gem "guard-yard",     :platforms => [:mri_24]
  gem "yard", ">=0.8.7.5", :platforms => [:mri_24]
end
