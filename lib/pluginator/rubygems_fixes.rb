unless Gem.respond_to? :find_files_from_load_path
  # older versions of rubygems od not have separate method for finding only on $LOAD_PATH
  # this is copy/paste from rubygems 2.0.0 code
  # :nocov: not testing as it runs only on old rubygems, it's not even our code
  module Gem
    def self.find_files_from_load_path(glob)
      $LOAD_PATH.map do |load_path|
        Dir["#{File.expand_path glob, load_path}#{Gem.suffix_pattern}"]
      end.flatten.select do |file| # rubocop:disable Style/MultilineBlockChain
        File.file? file.untaint
      end
    end
  end
  # :nocov:
end
