
require 'doc/functionresolver'

module Functions

  # Expand functions defined as a functional TeX type names starting with a
  # '\'. We have a \newvar{name}{replace} command which creates a Hash of vars
  # in the +Document+. This function finds all occurences of \name and parses
  # the following parameters.  Next the +functionresolver+ is called to replace
  # content in place. When a name has no match in the var resolver it is left
  # in place.
  #
  def Functions::expand par, functionresolver
    par.replace_all("(\\\\ruby\\{([^}]+)\\})",proc { | cmd | eval(cmd).to_s } )
  end

end

if $UNITTEST

  class Test_Functions < Test::Unit::TestCase

    def test_expand
      @funcresolver = FunctionResolver.new
      assert_equal(' \unknown test',expand([' \unknown test']))
      assert_equal('',expand(['\newvar{test}{me}']))
      assert_equal('me',@funcresolver.get('test'))
      assert_equal('me',expand(['\test']))
    end

  protected

    def expand a
      Functions::expand(Paragraph.new(a),@funcresolver).to_s
    end
  end

end

