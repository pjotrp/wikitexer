
module BasicFormatting

  # Replace markup with appropriate output
  def BasicFormatting::markup paragraph, creator
    paragraph.replace_all("(''([^']+)'')", proc { | buf | creator.italics(buf) } )
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

  class Test_BasicFormatting < Test::Unit::TestCase

    def test_remark
      par = Paragraph.new(["test % test\n","test \\% test"])
      assert_equal(["test \n","test \\% test"],BasicFormatting::remarks(par))
    end
  end

end
