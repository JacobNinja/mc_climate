require File.expand_path('./../test_helper', __FILE__)

class CacheTest < Test::Unit::TestCase

  attr_reader :repo_path, :commit_sha
  def setup
    @repo_path = 'path/to/repo'
    @commit_sha = 'xxx'
  end

  test 'fetch! returns analysis result from cache' do
    cache = {
        'path/to/repo' => {
            commit_sha => {
                'foo.rb' => [{'name' => { 'token' => 'foo',
                                          'line' => 1,
                                          'column' => 2},
                              'complexity' => 9000}]
            }
        }
    }
    sut = McClimate::Cache.new(cache)
    foo = McClimate::Nodes::Ident.new('foo', 1, 2)
    method_result = McClimate::ComplexityAnalyzer::Result.new(foo, 9000)
    expected = McClimate::ComplexityResult.new([method_result], 'foo.rb')
    assert_includes sut.fetch!(repo_path, commit_sha), expected
  end

  test 'fetch! sets result in cache if not found' do
    cache = {}
    sut = McClimate::Cache.new(cache)
    complexity_result = McClimate::ComplexityResult.new([McClimate::ComplexityAnalyzer::Result.new(McClimate::Nodes::Ident.new('foo'))], 'foo.rb')
    result = sut.fetch!(repo_path, commit_sha) { [complexity_result] }
    assert_includes result, complexity_result
    assert_not_empty cache
  end

end