
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
    if $style[:final]
      paragraph.replace_all("^(''([^']+)'')", proc { | buf, orig | buf } )
    else
      # highlight first sentence
      # paragraph.replace_all("^([^\.]+?)", proc { | buf, orig | p buf ; creator.italics(buf) } )
    end
    paragraph.replace_all("(''([^']+)'')", proc { | buf, orig | creator.italics(buf) } )
    paragraph.replace_all('(\*(\w+)\*)', proc { | buf, orig | creator.bold(buf) } )
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
      elsif (pos = s =~ /[^\\]%[^dsifl]/) # remark starts later in the line
        a[i] = s[0..pos]+"\n"
      end
    end
    paragraph.set(a)
    # set percentage, or other, symbol correctly
    if creator.respond_to?(:percentage)
      paragraph.replace_all("((\\\\%))", proc { | buf, orig | creator.percentage(buf) } )
    end
    paragraph.replace_all("((\\\\&))", proc { | buf, orig | creator.amp(buf) } )
  end

  # Boxed output of indented paragraph
  #
  def BasicFormatting::indented paragraph, creator
    a = paragraph.to_a
    is_indented = a.reduce(true) { |res, s| res && s =~ /^\s/ }
    is_empty = a.reduce(true) { |res, s| res && s.strip == "" }
    env = nil

    if is_indented and !is_empty
      if $indent_env != nil
        env = $indent_env
        # a.unshift "\\begin{#{env}}\n"
        # a.push "\\end{#{env}}\n"
        # paragraph.set(a)
      else
        a = a.map { | s | "<br />"+s }
        # literal
        a.push "<br /></div>"
        a.unshift "<div class=\"verbatim\">"
        paragraph.set(a)
      end
    end
    return is_indented, env
  end

end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_indented
      creator = HtmlCreator.new
      par = Paragraph.new(["line1\n","line2\n"])
      BasicFormatting::indented(par,creator)
      assert_equal("line1\nline2\n",par.to_string)
      par = Paragraph.new(["  line1\n","line2\n"])
      BasicFormatting::indented(par,creator)
      assert_equal("  line1\nline2\n",par.to_string)
      par = Paragraph.new(["  line1\n","  line2\n"])
      BasicFormatting::indented(par,creator)
      assert_equal("<div class=\"verbatim\"><br />  line1\n<br />  line2\n<br /></div>",par.to_string)
    end

    def test_markup
      # $style[:final] = true
      creator = HtmlCreator.new
      par = Paragraph.new(["''italics''"])
      assert_equal("<i>italics</i>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["''italics\nline2''"])
      assert_equal("<i>italics\nline2</i>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["'''bold'''"])
      assert_equal("<b>bold</b>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["'''''bold intalics'''''"])
      assert_equal("<i><b>bold intalics</b></i>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["<small>test</small>"])
      assert_equal("<SMALL>test</SMALL>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["<s>test</s>"])
      assert_equal("<S>test</S>",BasicFormatting::markup(par,creator).to_string)
      par = Paragraph.new(["<u>test</u>"])
      assert_equal("<U>test</U>",BasicFormatting::markup(par,creator).to_string)
    end

    def test_remark
      creator = HtmlCreator.new
      par = Paragraph.new(["test % test\n","test \\% test"])
      assert_equal("test \ntest % test",BasicFormatting::remarks(par,creator).to_string)
    end
  end

end
