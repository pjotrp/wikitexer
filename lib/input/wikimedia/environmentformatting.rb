

module EnvironmentFormatting

  def EnvironmentFormatting::markup paragraph, environments, creator
    paragraph.replace_all("(\\\\begin\\{([^}]+)\\})", proc { | name, orig, values | 
      # $stderr.print "#{name},#{orig},#{values}"
      env = Environment.new(name)
      environments.push(env)
      return creator.verbatim_start if name == 'verbatim'
      return creator.literal_start(name)
    }, 1)
    paragraph = paragraph.replace_all("(\\\\end\\{([^}]+)\\})", proc { | name, orig, values | 
      # p name,orig,values
      env = environments.pop(name)
      return creator.verbatim_end if name == 'verbatim'
      return creator.literal_end(name)
    }, 1)
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_EnvironmentFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      environments = EnvironmentStack.new
      par = Paragraph.new(["\\begin{verbatim}\n","\\end{verbatim}\n"])
      assert_equal("<pre>\n</pre>",EnvironmentFormatting::markup(par,environments,creator).to_s)
    end
  end

end
