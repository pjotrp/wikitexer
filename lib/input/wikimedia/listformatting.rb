# List formatting is unsatisfactory at this point. In particular only 
# a start <li> is used (to support multiple lines). But it kinda works, now.
#
module ListFormatting

  # Replace markup with appropriate output
  def ListFormatting::markup paragraph, creator
    # paragraph.replace_all("([* ]+([^\\n]+))", proc { | buf, orig | creator.bullet(buf) } )
    indent = 0
    paragraph.to_a.each_with_index do | line, index |
      if line =~ /(^[*]+)\s+/
        newindent = $1.size
        buf = $'
        buf = creator.bullet(buf)
        if newindent > indent
          buf = creator.bullets_start(buf)
          indent = newindent
        end
        if newindent < indent
          buf = creator.bullets_end('')+ buf
          indent = newindent
        end
        paragraph.set_line(index, buf)
      end
    end
    while indent > 0
      index = paragraph.size-1
      buf = paragraph[index]
      paragraph.set_line(index, creator.bullets_end(buf))
      indent = indent - 1
    end
    paragraph
  end
end

if $UNITTEST

  require 'output/html/htmlcreator'

  class Test_ListFormatting < Test::Unit::TestCase

    def test_expand
      creator = HtmlCreator.new
      par = Paragraph.new("test\n* list1\n")
      assert_equal("test\n<ul><li>list1\n</ul>\n",ListFormatting::markup(par,creator).to_s)
      par = Paragraph.new("test\n* list1\n* list2\n")
      assert_equal("test\n<ul><li>list1\n<li>list2\n</ul>\n",ListFormatting::markup(par,creator).to_s)
      par = Paragraph.new("test\n* list1\n** list2\n")
      assert_equal("test\n<ul><li>list1\n<ul><li>list2\n</ul>\n</ul>\n",ListFormatting::markup(par,creator).to_s)
      par = Paragraph.new("test\n* list1\n** list2\n** List 3\n* List 4\n")
      assert_equal("test\n<ul><li>list1\n<ul><li>list2\n<li>List 3\n</ul><li>List 4\n</ul>\n",ListFormatting::markup(par,creator).to_s)
    end
  end

end
