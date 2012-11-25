
require 'input/support/citationfunctions'
require 'input/support/filefunctions'
require 'input/support/codefunctions'
require 'input/support/latexfunctions'
require 'input/support/formatterfunctions'

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

  # include CitationFunctions - specific for HTML
  include FileFunctions
  include FormatterFunctions
  include CodeFunctions
  include LatexFunctions

  def initialize(writer)
    @writer = writer
    @lookup = { 'newvar' => 'newvar' }
  end

  # Create a new variable
  def newvar name, body
    v = NewVar.new(name, body)
    @lookup[name] = v
  end

  def hasmethod? name
    @lookup.include?(name) or respond_to?(name.to_sym) or @writer.respond_to?(name.to_sym)
  end

  def send_formatter name, *args
    if @lookup.include?(name) or respond_to?(name.to_sym) 
      send(name,*args)
    elsif @writer.respond_to?(name.to_sym)
      @writer.send(name,*args)
    else 
      raise "Method "+name+" not found in function resolver"
    end
  end

  # If a method modifies the document state it should be in this list - and gets passed
  # the document as a parameter.
  def docmodify? name
    ['cite'].index(name) != nil
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
      assert(resolver.hasmethod?('newvar')==true,"hasmethod? fails for newvar")
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


