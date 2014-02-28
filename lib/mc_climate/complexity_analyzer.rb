require File.expand_path('./../matchers/integer_matcher', __FILE__)
require File.expand_path('./../matchers/math_matcher', __FILE__)

module McClimate

  class ComplexityAnalyzer

    Result = Struct.new(:name, :complexity) do

      def self.deserialize(attrs)
        name_attrs = attrs['name']
        name = Nodes::Ident.new(name_attrs['token'], name_attrs['line'], name_attrs['column'])
        new(name, attrs['complexity'])
      end

      def serialize
        {name: {token: name.token, line: name.line, column: name.column}, complexity: complexity}
      end

    end

    def initialize(node)
      @node = node
    end

    def call
      # does this confuse code climate?
      Result.new(@node.ident, complexity_score)
    end; private; def complexity_score
      @node.deep_match([Matchers::IntegerMatcher, Matchers::MathMatcher]).count.next
    end

  end

end
