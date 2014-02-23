module McClimate
  module Matchers

    class IntegerMatcher

      def self.match?(node)
        node.kind_of? Nodes::Int
      end

    end

  end
end