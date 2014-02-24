require File.expand_path('./../mc_climate/repository', __FILE__)
require File.expand_path('./../mc_climate/commit', __FILE__)
require File.expand_path('./../mc_climate/blob', __FILE__)
require File.expand_path('./../mc_climate/complexity_analyzer', __FILE__)
require File.expand_path('./../mc_climate/parser', __FILE__)
require File.expand_path('./../mc_climate/reporter', __FILE__)
require File.expand_path('./../mc_climate/cache', __FILE__)
require File.expand_path('./../mc_climate/result_diff', __FILE__)

module McClimate

  COMPLEXITY_THRESHOLD = 10

  ComplexityResult = Struct.new(:method_results, :file) do

    def self.deserialize(attrs)
      new(attrs['method_results'], attrs['file'])
    end

  end

  def self.complexity(rb, file='-')
    complexity_analyzers = Parser.defns(rb).map do |defn_node|
      ComplexityAnalyzer.new(defn_node)
    end
    ComplexityResult.new(complexity_analyzers.map(&:call), file)
  end

end