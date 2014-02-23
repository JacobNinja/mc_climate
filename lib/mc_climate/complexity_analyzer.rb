require File.expand_path('./../matchers/integer_matcher', __FILE__)
require File.expand_path('./../matchers/math_matcher', __FILE__)

module McClimate

  class ComplexityAnalyzer

    Result = Struct.new(:name, :complexity)

    def initialize(node)
      @node = node
    end

    def call
      Result.new(@node.ident, complexity_score)
    end

    private

    def complexity_score
      @node.deep_match([Matchers::IntegerMatcher, Matchers::MathMatcher]).count.next
    end

  end

end