
module BasicFormatting

  # Replace typical Wiki markup with appropriate output. 
  #
  #   '''      bold
  #   ''       italic
  #   <small>  small font
  #   <s>      strike out
  #   <u>      underline
  #
  def BasicFormatting::markup paragraph, creator
    paragraph.replace_all("('''''([^']+)''''')", proc { | buf, orig | creator.italics(creator.bold(buf)) } )
    paragraph.replace_all("('''([^']+)''')", proc { | buf, orig | creator.bold(buf) } )
    paragraph.replace_all("(''([^']+)'')", proc { | buf, orig | creator.italics(buf) } )
    paragraph.replace_all("(<small>(.*?)<\/small>)", proc { | buf, orig | creator.small(buf) } )
    paragraph.replace_all("(<s>(.*?)<\/s>)", proc { | buf, orig | creator.strikeout(buf) } )
    paragraph.replace_all("(<u>(.*?)<\/u>)", proc { | buf, orig | creator.underline(buf) } )
  end

  # Remove remarks from the text body
  #
  #   %        remarks start with a percentage on the first column
  #
  def BasicFormatting::remarks paragraph, creator
    a = paragraph.to_a
    a.each_with_index do | s, i |
      if (s =~ /^%\s/)  # line starts with perc and space
        a[i] = "\n"
      elsif (pos = s =~ /[^\\]%[^dsifl]/)
        # p pos
        a[i] = s[0..pos]+"\n"
      end
    end
    paragraph.set(a)
    # set percentage symbol correctly
    paragraph.replace_all("((\\\\%))", proc { | buf, orig | creator.percentage(buf) } )
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_markup
      creator = HtmlCreator.new
      par = Paragraph.new(["''italics''"])
      assert_equal("<i>italics</i>",BasicFormatting::markup(par,creator).to_s)
      par = Paragraph.new(["''italics\nline2''"])
      assert_equal("<i>italics\nline2</i>",BasicFormatting::markup(par,creator).to_s)
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
      creator = HtmlCreator.new
      par = Paragraph.new(["test % test\n","test \\% test"])
      assert_equal("test \ntest % test",BasicFormatting::remarks(par,creator).to_s)
    end
  end

end
