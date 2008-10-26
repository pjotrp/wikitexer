
class NewVar
  attr_reader :name, :body
  def initialize name, body
    @name = name
    @body = body
  end

  def value
    @body
  end
end

class Func
end

# FunctionResolver provides a mechanism for function lookups. It does not care
# for the syntax - just passes data around.
#
class FunctionResolver

  def initialize
    @lookup = { 'newvar' => 'newvar' }
  end

  # Create a new variable
  def newvar name, body
    v = NewVar.new(name, body)
    @lookup[name] = v
  end

  def hasmethod? name
    @lookup[name] != nil
  end

  def [] name
    @lookup[name].value
  end
end


if $UNITTEST

  class Test_FunctionResolver < Test::Unit::TestCase

    def test_resolver
      resolver = FunctionResolver.new
      assert(!resolver.hasmethod?('test'))
      resolver.newvar('test','me')
      assert(!resolver.hasmethod?('testme'))
      assert(resolver.hasmethod?('test'))
      assert_equal('me',resolver['test'])
      # assert_equal('me',resolver['unknown'])
    end

  end
end


