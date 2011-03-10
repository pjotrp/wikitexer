
require 'doc/functionresolver'

module Functions

  # Expand functions defined as a functional TeX type names starting with a
  # '\'. We have a \newvar{name}{replace} command which creates a Hash of vars
  # in the +Document+. This function finds all occurences of \name and parses
  # the following parameters.  Next the +functionresolver+ is called to replace
  # content in place. When a name has no match in the var resolver it is left
  # in place.
  #
  def Functions::expand par, document
    functionresolver = document.functionresolver
    # get all newvars and store them in the functionresolver
    par.replace_all("(\\\\newvar\\{([^}]+)\\}\\{([^}]+)\\})", proc { | name, orig, values |
      body = values[0]
      functionresolver.newvar(name,body)
      return ''  
    }, 1 )
    # get all single arg functions
    par.replace_all("(\\\\(\\w+)\\{([^}]+)\\})", proc { | funcname, orig, values |
      var = values[0]
      if functionresolver.hasmethod?(funcname)
        if functionresolver.docmodify?(funcname)
          return functionresolver.send(funcname,document,var)
        else
          return functionresolver.send(funcname,var)
        end
      end
      return remove_marker(orig)
    }, 1 )
    # Expand all known variables with trailing backslash
    par.replace_all("(\\\\(\\w+)(\\\\)(\\W))", proc { | funcname, orig, values |
      if functionresolver.hasvar?(funcname)
        return functionresolver[funcname]+values[1]
      end
      return remove_marker(orig)
    }, 2)
    # Expand all remaining
    par.replace_all("(\\\\(\\w+))", proc { | funcname, orig |
      if functionresolver.hasvar?(funcname)
        return functionresolver[funcname]
      end
      return remove_marker(orig)
    } )
    restore_markers(par)
  end

protected

  def Functions::remove_marker(s)
    '@__@'+s[1..-1]
  end

  def Functions::restore_markers par
    par.replace_all("((@__@))", proc { | nothing, orig | "\\" } )
  end

end

if $UNITTEST

  class Test_Functions < Test::Unit::TestCase

    def test_expand
      @document = Document.new
      @funcresolver = @document.functionresolver
      # do not expand unknown
      assert_equal(' \unknown test',expand([' \unknown test']))
      assert_equal('',expand(['\newvar{test}{me}']))
      assert_equal('me',@funcresolver['test'])
      assert_equal('1 me,',expand(['1 \test\,']))
      assert_equal('2 me',expand(['2 \test']))
      assert_equal('3 me test',expand(['3 \test\ test']))
      assert_equal('4 meme',expand(['4 \test\test']))
      assert_equal('5 \unknown test',expand(['5 \unknown test']))
      assert_equal('6 \reallyunknown test',expand(['6 \reallyunknown test']))
      assert_equal('7 \reallyunknown\ test',expand(['7 \reallyunknown\ test']))
    end

    def test_function_parameters
      @document = Document.new
      @funcresolver = @document.functionresolver
      assert_equal('testme',expand(['\dummy{testme}']))
      assert_equal('testje',expand(['\insertfile{test/data/insertfile.txt}']).strip)
    end

  protected

    def expand a
      Functions::expand(Paragraph.new(a),@document).to_string
    end
  end

end

