module McClimate
  module Matchers

    class MathMatcher

      INTERESTING_OPERATORS = %i(+ - * /)

      def self.match?(node)
        node.kind_of?(Nodes::Binary) && INTERESTING_OPERATORS.include?(node.operator)
      end

    end

  end
end