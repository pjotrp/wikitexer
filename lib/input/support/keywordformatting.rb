
module KeywordFormatting

  # Replace special markup with appropriate output - e.g. highlight FIXME
  def KeywordFormatting::markup paragraph, creator
    paragraph.replace_each_line_once("((FIXME\\W))", proc { | buf, orig | creator.keyword(buf) } )
  end
end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      par = Paragraph.new(["FIXME\n"])
      assert_equal("<font color='RED'><b>FIXME\n</b></font>\n",KeywordFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["(FIXME) \n"])
      assert_equal("(<font color='RED'><b>FIXME)</b></font>\n",KeywordFormatting::markup(par,creator).to_s)
    end
  end

end
