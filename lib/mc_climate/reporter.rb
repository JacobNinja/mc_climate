module McClimate

  class Reporter

    Comparison = Struct.new(:file, :name, :complexity)

    def initialize(result)
      @result = result
    end

    def complexity_greater_than(num)
      results_with_complexity_greater_than(num).map do |result|
        "WARNING: '##{result.name.token}' (line #{result.name.line}, column #{result.name.column}) in #{@result.file} has a complexity of #{result.complexity}."
      end.join("\n")
    end

    def compare(other_result)
      result_diff = ResultDiff.new(comparisons(@result), comparisons(other_result))
      new_messages = result_diff.new.map do |new_result|
        "NEW: '##{new_result.name.token}' (line #{new_result.name.line}, column #{new_result.name.column}) in #{new_result.file} has a complexity of #{new_result.complexity}"
      end
      [:fixed, :worse, :improved].reduce(new_messages) do |whole_message, type|
        whole_message + result_diff.public_send(type).map do |result|
          "#{result.to_s.capitalize}: '##{result.name.token}' (line #{result.name.line}, column #{result.name.column}) in #{result.file} has a complexity of #{result.complexity} (was #{result.was})"
        end
      end.join("\n")
    end

    private

    def results_with_complexity_greater_than(num)
      @result.method_results.select do |result|
        result.complexity > num
      end
    end

    def comparisons(results)
      results.flat_map do |result|
        result.method_results.map do |method_result|
          Comparison.new(result.file, method_result.name, method_result.complexity)
        end
      end
    end

  end

end