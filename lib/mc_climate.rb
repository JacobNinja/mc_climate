require File.expand_path('./../mc_climate/complexity_analyzer', __FILE__)
require File.expand_path('./../mc_climate/parser', __FILE__)

module McClimate

  def self.complexity(rb)
    complexity_analyzers = Parser.defns(rb).map do |defn_node|
      ComplexityAnalyzer.new(defn_node)
    end
    complexity_analyzers.map(&:call)
  end

end