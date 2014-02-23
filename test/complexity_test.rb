require File.expand_path('./../../lib/mc_climate', __FILE__)
require 'test/unit'

class ComplexityTest < Test::Unit::TestCase

  def assert_complexity(method_name, expected_complexity, result)
    assert_not_empty result, 'Expected result not to be empty'
    expected_method = result.find {|m| m.name == method_name }
    assert_not_nil expected_method, "Expected to find method #{method_name}"
    assert_equal expected_complexity, expected_method.complexity
  end

  test 'method without body' do
    assert_complexity 'foo', 1, McClimate.complexity(<<-RUBY)
def foo
end
    RUBY
  end

  test 'method containing integer' do
    assert_complexity 'foo', 2, McClimate.complexity(<<-RUBY)
def foo
  1
end
    RUBY
  end

  test 'method containing addition' do
    assert_complexity 'foo', 2, McClimate.complexity(<<-RUBY)
def foo
  bar + bar
end
    RUBY
  end

  test 'method containing subtraction' do
    assert_complexity 'foo', 2, McClimate.complexity(<<-RUBY)
def foo
  bar - bar
end
    RUBY
  end

  test 'method containing multiplication' do
    assert_complexity 'foo', 2, McClimate.complexity(<<-RUBY)
def foo
  bar * bar
end
    RUBY
  end

  test 'method containing division' do
    assert_complexity 'foo', 2, McClimate.complexity(<<-RUBY)
def foo
  bar / bar
end
    RUBY
  end

  test 'method containing uninteresting arithmetic' do
    assert_complexity 'foo', 1, McClimate.complexity(<<-RUBY)
def foo
  bar ^ foo
end
    RUBY
  end

  test 'method containing combination of integers and interesting arithmetic' do
    assert_complexity 'foo', 5, McClimate.complexity(<<-RUBY)
def foo
  x = 1 * 2 + y
end
    RUBY
  end

end