module McClimate

  class Reporter

    def initialize(result)
      @result = result
    end

    def complexity_greater_than(num)
      results_with_complexity_greater_than(num).map do |result|
        "WARNING: '##{result.name.token}' (line #{result.name.line}, column #{result.name.column}) in #{@result.file} has a complexity of #{result.complexity}."
      end.join("\n")
    end

    private

    def results_with_complexity_greater_than(num)
      @result.method_results.select do |result|
        result.complexity > num
      end
    end

  end

end