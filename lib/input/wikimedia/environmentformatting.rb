

module EnvironmentFormatting

  def EnvironmentFormatting::markup paragraph, environments, creator
    last_env = nil
    paragraph.replace_all("(\\\\begin\\{([^}]+)\\})", proc { | name, orig, values | 
      # $stderr.print "#{name},#{orig},#{values}"
      env = Environment.new(name)
      environments.push(env)
      # last_env = name
      case name
        when 'verbatim' then return creator.verbatim_start
        when 'quote'    then return creator.quote_start
        when 'quotation'then return creator.quote_start
        when 'ruby'     then return creator.ruby_start
        when 'shell'    then return creator.shell_start
        when 'python'   then return creator.python_start
        when 'perl'     then return creator.perl_start
        when 'scala'    then return creator.scala_start
        when 'cmake'    then return creator.cmake_start
        when 'c'        then return creator.c_start
        when 'r'        then return creator.r_start
        when 'swig'     then return creator.swig_start
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
        when 'verbatim' then return creator.verbatim_end
        when 'quote'    then return creator.quote_end
        when 'quotation' then return creator.quote_end
        when 'ruby'     then return creator.ruby_end
        when 'shell'    then return creator.shell_end
        when 'python'   then return creator.python_end
        when 'perl'     then return creator.perl_end
        when 'scala'    then return creator.scala_end
        when 'cmake'    then return creator.cmake_end
        when 'r'        then return creator.r_end
        when 'c'        then return creator.c_end
        when 'swig'     then return creator.swig_end
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
