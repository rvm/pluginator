# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :minitest do
  watch(%r{^lib/plugins/pluginator/(.*/)?([^/]+)\.rb$}) { |m|
    "test/plugins_test/#{m[1]}#{m[2]}_test.rb"
  }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m|
    "test/#{m[1]}#{m[2]}_test.rb"
  }
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^test/test_helper\.rb$})  { 'test' }
end

guard 'yard' do
  watch(%r{app/.+\.rb})
  watch(%r{lib/.+\.rb})
  watch(%r{ext/.+\.c})
end
