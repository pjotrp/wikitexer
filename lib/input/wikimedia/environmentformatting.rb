

module EnvironmentFormatting

  def EnvironmentFormatting::markup paragraph, environments, creator
    last_env = nil
    paragraph.replace_all("(\\\\begin\\{([^}]+)\\})", proc { | name, orig, values | 
      # $stderr.print "#{name},#{orig},#{values}"
      env = Environment.new(name)
      environments.push(env)
      # last_env = name
      case name
        when 'verbatim' : return creator.verbatim_start
        when 'ruby'     : return creator.ruby_start
        when 'shell'    : return creator.shell_start
        when 'python'   : return creator.python_start
        when 'perl'     : return creator.perl_start
        when 'cmake'    : return creator.cmake_start
        when 'c'        : return creator.c_start
        when 'swig'     : return creator.swig_start
      else
        $stderr.print "Warning: unknown literal #{name}\n"
        return creator.literal_start(name)
      end
    }, 1)
    paragraph = paragraph.replace_all("(\\\\end\\{([^}]+)\\})", proc { | name, orig, values | 
      # p name,orig,values
      env = environments.pop(name)
      last_env = name
      case name
        when 'verbatim' : return creator.verbatim_end
        when 'ruby'     : return creator.ruby_end
        when 'shell'    : return creator.shell_end
        when 'python'   : return creator.python_end
        when 'perl'     : return creator.perl_end
        when 'cmake'    : return creator.cmake_end
        when 'c'        : return creator.c_end
        when 'swig'     : return creator.swig_end
      else
        return creator.literal_end(name)
      end
    }, 1)
    # $stderr.print last_env,'=',paragraph.to_s
    return paragraph,last_env
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_EnvironmentFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      environments = EnvironmentStack.new
      par = Paragraph.new(["\\begin{verbatim}\n","\\end{verbatim}\n"])
      # p EnvironmentFormatting::markup(par,environments,creator)
      assert_equal("<pre>\n</pre>verbatim",EnvironmentFormatting::markup(par,environments,creator).to_s)
    end
  end

end
