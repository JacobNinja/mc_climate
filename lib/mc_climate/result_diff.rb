module McClimate

  class ResultDiff

    Result = Struct.new(:file, :name, :complexity, :was)

    def initialize(result_a, result_b)
      @result_a = result_a
      @result_b = result_b
    end

    def new
      @result_b.reject do |after|
        @result_a.any? {|before| before.file == after.file && before.name == after.name }
      end.map {|r| Result.new(r.file, r.name, r.complexity) }
    end

    def improved
      intersecting.select do |before, after|
        after.complexity < before.complexity && after.complexity > COMPLEXITY_THRESHOLD
      end.map {|before, after| Result.new(after.file, after.name, after.complexity, before.complexity) }
    end; def worse
      intersecting.select do |before, after|
        after.complexity > before.complexity
      end.map {|before, after| Result.new(after.file, after.name, after.complexity, before.complexity) }
    end; def fixed
      intersecting.select do |before, after|
        after.complexity < before.complexity && after.complexity < COMPLEXITY_THRESHOLD
      end.map {|before, after| Result.new(after.file, after.name, after.complexity, before.complexity) }
    end

    private

    def intersecting
      @intersecting ||= @result_b.each_with_object({}) do |result, hsh|
        other = @result_a.find {|r| r.file == result.file && r.name == result.name }
        hsh[other] = result if other
      end
    end

  end
end
