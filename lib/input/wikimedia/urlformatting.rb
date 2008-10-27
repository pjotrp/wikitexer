
module UrlFormatting

  # Replace markup with appropriate output
  def UrlFormatting::markup paragraph, creator
    paragraph.replace_all('(\[([^\]]+)\])', proc { | buf, orig | creator.url(buf) } )
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_UrlFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      par = Paragraph.new(["[http://link Test]"])
      assert_equal("<a href=\"http://link\">Test</a>",UrlFormatting::markup(par,creator).to_s)
    end

  end

end
