module McClimate

  class Cache

    def initialize(cache={})
      @cache = cache
    end

    def fetch!(repo_path, commit_sha, &block)
      repo_cache = @cache[repo_path] ||= {}
      if repo_cache.has_key?(commit_sha)
        deserialize(repo_cache[commit_sha])
      else
        block.call.tap do |results|
          repo_cache.merge!(commit_sha => serialize(results))
        end
      end
    end

    def save
      @cache.save
    end

    private

    def serialize(complexity_results)
      complexity_results.group_by(&:file).each_with_object({}) do |(file, results), file_cache|
        file_cache[file] = results.flat_map(&:method_results).map(&:serialize)
      end
    end

    def deserialize(serialized_results)
      serialized_results.flat_map do |(file, serialized_file_results)|
        method_results = serialized_file_results.map(&ComplexityAnalyzer::Result.method(:deserialize))
        ComplexityResult.new(method_results, file)
      end
    end

  end

end