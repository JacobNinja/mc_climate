require 'delegate'
require 'json'

module McClimate

  class FileSystemCache < SimpleDelegator

    def initialize(cache_path)
      @cache_path = cache_path
      __setobj__(cache)
    end

    def save
      File.open(@cache_path, 'w') do |f|
        f.write JSON.dump(cache)
      end
    end

    private

    def cache
      @cache ||= File.exists?(@cache_path) ? JSON.parse(File.read(@cache_path)) : {}
    end

  end
end