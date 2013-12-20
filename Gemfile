source "https://rubygems.org"

#ruby=2.0.0

gemspec

group :development do
  # statistics only on MRI 2.0 - avoid problems on older rubies
  gem "redcarpet", :platforms => [:mri_20]
  gem "simplecov", :platforms => [:mri_20]
  gem "coveralls", :platforms => [:mri_20]

  # rubinius support
  gem "rubysl-json",      :platforms => [:rbx]
  gem "rubysl-mutex_m",   :platforms => [:rbx]
  gem "rubysl-singleton", :platforms => [:rbx]
end
