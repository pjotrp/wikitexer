
module BasicFormatting

  # Replace markup with appropriate output
  def BasicFormatting::markup paragraph, creator
    paragraph.replace_all("('''''([^']+)''''')", proc { | buf | creator.italics(creator.bold(buf)) } )
    paragraph.replace_all("('''([^']+)''')", proc { | buf | creator.bold(buf) } )
    paragraph.replace_all("(''([^']+)'')", proc { | buf | creator.italics(buf) } )
    paragraph.replace_all("(<small>(.*?)<\/small>)", proc { | buf | creator.small(buf) } )
    paragraph.replace_all("(<s>(.*?)<\/s>)", proc { | buf | creator.strikeout(buf) } )
    paragraph.replace_all("(<u>(.*?)<\/u>)", proc { | buf | creator.underline(buf) } )
  end

  # Remove remarks
  def BasicFormatting::remarks paragraph
    a = paragraph.to_a
    a.each_with_index do | s, i |
      if (pos = s =~ /[^\\]%/)
        p pos
        a[i] = s[0..pos]+"\n"
      end
    end
    paragraph.set(a)
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      par = Paragraph.new(["''italics''"])
      assert_equal("<i>italics</i>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["'''bold'''"])
      assert_equal("<b>bold</b>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["'''''bold intalics'''''"])
      assert_equal("<i><b>bold intalics</b></i>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["<small>test</small>"])
      assert_equal("<SMALL>test</SMALL>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["<s>test</s>"])
      assert_equal("<S>test</S>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["<u>test</u>"])
      assert_equal("<U>test</U>",BasicFormatting::markup(par,creator).to_s)
    end

    def test_remark
      par = Paragraph.new(["test % test\n","test \\% test"])
      assert_equal(["test \n","test \\% test"],BasicFormatting::remarks(par))
    end
  end

end
