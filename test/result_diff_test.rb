require File.expand_path('./../test_helper', __FILE__)

class ResultDiffTest < Test::Unit::TestCase

  attr_reader :foo
  def setup
    @foo = McClimate::Nodes::Ident.new('foo', 1, 2)
  end

  test 'new methods' do
    a = [McClimate::Reporter::Comparison.new('foo.rb', foo, 2)]
    b = [McClimate::Reporter::Comparison.new('foo.rb', 'bar', 3)]
    sut = McClimate::ResultDiff.new(a, b)
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', 'bar', 3)], sut.new
  end

  test 'improved methods' do
    a = [McClimate::Reporter::Comparison.new('foo.rb', foo, 30)]
    b = [McClimate::Reporter::Comparison.new('foo.rb', foo, 20)]
    sut = McClimate::ResultDiff.new(a, b)
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', foo, 20, 30)], sut.improved
  end

  test 'worse methods' do
    a = [McClimate::Reporter::Comparison.new('foo.rb', foo, 20)]
    b = [McClimate::Reporter::Comparison.new('foo.rb', foo, 50)]
    sut = McClimate::ResultDiff.new(a, b)
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', foo, 50, 20)], sut.worse
  end

  test 'fixed methods' do
    a = [McClimate::Reporter::Comparison.new('foo.rb', foo, 50)]
    b = [McClimate::Reporter::Comparison.new('foo.rb', foo, 5)]
    sut = McClimate::ResultDiff.new(a, b)
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', foo, 5, 50)], sut.fixed
  end

  test 'combination' do
    a = [McClimate::Reporter::Comparison.new('foo.rb', 'fixme', 10), McClimate::Reporter::Comparison.new('zoom/baz.rb', 'warmer', 23), McClimate::Reporter::Comparison.new('boom/bop.rb', 'nope', 3)]
    b = [McClimate::Reporter::Comparison.new('foo.rb', 'new_method', 11), McClimate::Reporter::Comparison.new('foo.rb', 'fixme', 3),  McClimate::Reporter::Comparison.new('zoom/baz.rb', 'warmer', 13), McClimate::Reporter::Comparison.new('boom/bop.rb', 'nope', 42)]
    sut = McClimate::ResultDiff.new(a, b)
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', 'new_method', 11)], sut.new
    assert_equal [McClimate::ResultDiff::Result.new('foo.rb', 'fixme', 3, 10)], sut.fixed
    assert_equal [McClimate::ResultDiff::Result.new('zoom/baz.rb', 'warmer', 13, 23)], sut.improved
    assert_equal [McClimate::ResultDiff::Result.new('boom/bop.rb', 'nope', 42, 3)], sut.worse
  end

end