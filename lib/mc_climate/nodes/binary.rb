module McClimate
  module Nodes

    class Binary

      include Enumerable

      attr_reader :lh, :operator, :rh

      def initialize(lh, operator, rh)
        @lh = lh
        @operator = operator
        @rh = rh
      end

      def each
        [lh, rh]
      end

    end

  end
end