require File.expand_path('./../mc_climate/repository', __FILE__)
require File.expand_path('./../mc_climate/commit', __FILE__)
require File.expand_path('./../mc_climate/blob', __FILE__)
require File.expand_path('./../mc_climate/complexity_analyzer', __FILE__)
require File.expand_path('./../mc_climate/parser', __FILE__)
require File.expand_path('./../mc_climate/reporter', __FILE__)

module McClimate

  ComplexityResult = Struct.new(:method_results, :file)

  def self.complexity(rb, file='-')
    complexity_analyzers = Parser.defns(rb).map do |defn_node|
      ComplexityAnalyzer.new(defn_node)
    end
    ComplexityResult.new(complexity_analyzers.map(&:call), file)
  end

end