
MARKWORDS = "
like show often usually always any appears popular allow easy
particular now large small many we our more most allows interesting interest
use using used potential very extreme usage impressive
".split

NOMARKWORDS = "including".split

module KeywordFormatting

  # Replace special markup with appropriate output - e.g. highlight FIXME
  def KeywordFormatting::markup paragraph, creator
    paragraph.replace_each_line_once("((FIXME\\W))", proc { | buf, orig | creator.keyword(buf) } )
    MARKWORDS.each do | word |
      # paragraph.replace_each_line_once("((\\W#{word}\\W))", proc { | buf, orig | creator.markword(buf) } )
      paragraph.replace_each_line_once("((\\W#{word}(ing|ly)?\\W))", proc { | buf, orig | creator.markword(buf) } )
      paragraph.replace_each_line_once("((\\W#{word.capitalize}(ing|ly)?\\W))", proc { | buf, orig | creator.markword(buf) } )
    end
    paragraph.replace_each_line_once("((\/wrk\/))", proc { | buf, orig | '/pjotrp/' } )
  end
end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_markup1
      creator = HtmlCreator.new
      par = Paragraph.new(["FIXME\n"])
      assert_equal("<font color='RED'><b>FIXME\n</b></font>\n",KeywordFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["(FIXME) \n"])
      assert_equal("(<font color='RED'><b>FIXME)</b></font>\n",KeywordFormatting::markup(par,creator).to_string)
    end
  end

end
