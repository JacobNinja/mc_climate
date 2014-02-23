module McClimate
  module Nodes

    class Int

      attr_reader :token, :line, :column

      def initialize(token, line, column)
        @token = token
        @line = line
        @column = column
      end

    end

  end
end