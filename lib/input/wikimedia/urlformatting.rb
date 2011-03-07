
module UrlFormatting

  # Replace markup with appropriate output
  def UrlFormatting::markup paragraph, creator
    # Find markup that starts with a square bracket and ends with one, and
    # convert it to an href. This edition requires a URL.
    paragraph.replace_all('(\[(https?:[^\]]+)\])', proc { | buf, orig | creator.url(buf) } )
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_UrlFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      par = Paragraph.new(["[http://link Test]"])
      assert_equal("<a href=\"http://link\">Test</a>",UrlFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["[http://link Test me]"])
      assert_equal("<a href=\"http://link\">Test me</a>",UrlFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["[http://link * Test me]"])
      assert_equal("<a href=\"http://link\">* Test me</a>",UrlFormatting::markup(par,creator).to_string)
    end

  end

end
