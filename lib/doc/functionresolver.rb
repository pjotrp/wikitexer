
require 'input/support/filefunctions'

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
# for the syntax - just passes data around. It is extended by special modules.
#
class FunctionResolver

  include FileFunctions

  def initialize
    @lookup = { 'newvar' => 'newvar' }
  end

  # Create a new variable
  def newvar name, body
    v = NewVar.new(name, body)
    @lookup[name] = v
  end

  def hasmethod? name
    methods.include?(name)
  end

  def methodcall funcname
  end

  def hasvar? name
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
      assert(!resolver.hasvar?('test'))
      assert(resolver.hasmethod?('newvar'))
      resolver.newvar('test','me')
      assert(!resolver.hasvar?('testme'))
      assert(resolver.hasvar?('test'))
      assert_equal('me',resolver['test'])
      # assert_equal('me',resolver['unknown'])
      assert_equal('testDummy',resolver.dummy)
      assert(resolver.hasmethod?('dummy'))
    end

  end
end


