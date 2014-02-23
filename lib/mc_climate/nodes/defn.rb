module McClimate
  module Nodes

    class Defn

      attr_reader :ident

      def initialize(ident, body)
        @ident = ident
        @body = body
      end

      def deep_match(filters, coll=@body)
        matching_nodes = coll.select {|n| filters.any? {|filter| filter.match?(n) } }
        coll.reduce(matching_nodes) do |acc, n|
          if n.respond_to?(:each)
            acc + deep_match(filters, n.each)
          else
            acc
          end
        end
      end

    end

  end
end