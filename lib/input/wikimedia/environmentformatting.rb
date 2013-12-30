

module EnvironmentFormatting

  def EnvironmentFormatting::markup paragraph, environments, creator
    last_env = nil
    return paragraph,'abstract' if paragraph.to_string.index('{abstract}')
    return paragraph,'author' if paragraph.to_string.index('{author}')
    return paragraph,'tabular' if paragraph.to_string.index('{tabular}')
    return paragraph,'table' if paragraph.to_string.index('{table}')
    paragraph.replace_all("(\\\\begin\\{([^}]+?)\\})", proc { | name, orig, values | 
      # $stderr.print "#{name},#{orig},#{values}"
      env = Environment.new(name)
      environments.push(env) if environments
      # last_env = name
      # Basically this inserts a 'div' class:
      case name
        when 'verbatim' then creator.verbatim_start
        when 'quote'    then creator.quote_start
        when 'quotation'then creator.quote_start
        when 'ruby'     then creator.ruby_start
        when 'shell'    then creator.shell_start
        when 'python'   then creator.python_start
        when 'perl'     then creator.perl_start
        when 'scala'    then creator.scala_start
        when 'cmake'    then creator.cmake_start
        when 'c'        then creator.c_start
        when 'r'        then creator.r_start
        when 'swig'     then creator.swig_start
      else
        $stderr.print "Warning: unknown literal #{name}\n"
        creator.literal_start(name)
      end
    }, 1)
    paragraph = paragraph.replace_all("(\\\\end\\{([^}]+?)\\})", proc { | name, orig, values | 
      # p name,orig,values
      env = environments.pop(name) if environments
      last_env = name
      case name
        when 'verbatim' then creator.verbatim_end
        when 'quote'    then creator.quote_end
        when 'quotation'then creator.quote_end
        when 'ruby'     then creator.ruby_end
        when 'shell'    then creator.shell_end
        when 'python'   then creator.python_end
        when 'perl'     then creator.perl_end
        when 'scala'    then creator.scala_end
        when 'cmake'    then creator.cmake_end
        when 'r'        then creator.r_end
        when 'c'        then creator.c_end
        when 'swig'     then creator.swig_end
      else
        creator.literal_end(name)
      end
    }, 1)
    return paragraph,last_env
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_EnvironmentFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      environments = EnvironmentStack.new
      par = Paragraph.new(["\\begin{verbatim}\n","test\n","\\end{verbatim}\n"])
      par2,env =  EnvironmentFormatting::markup(par,environments,creator)
      assert_equal("<pre>\ntest\n</pre>",par2.to_string)
    end
  end

end
