require File.expand_path('./../nodes/defn', __FILE__)
require File.expand_path('./../nodes/ident', __FILE__)
require File.expand_path('./../nodes/int', __FILE__)
require File.expand_path('./../nodes/binary', __FILE__)
require 'ripper'

module McClimate

  class Parser < Ripper::SexpBuilderPP

    def self.defns(rb)
      parser = new(rb)
      parser.parse
      parser.nodes
    end

    def parse(*)
      @nodes = []
      super
    end

    attr_reader :nodes

    def on_ident(token)
      Nodes::Ident.new(token, lineno(), column())
    end

    def on_int(token)
      Nodes::Int.new(token, lineno(), column())
    end

    def on_def(ident, params, body)
      @nodes << Nodes::Defn.new(ident, body)
      super
    end

    def on_binary(lh, operator, rh)
      Nodes::Binary.new(lh, operator, rh)
    end

  end

end