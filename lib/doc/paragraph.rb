
class Paragraph

  attr_accessor :hastitle

  def initialize par
    @original = par.clone
    @current  = set(par)
    hastitle = false
  end
 
  # Sets the paragraph buffer to an Array - each item ending in an eol.
  def set buf
    if buf.kind_of? String
      a = buf.split(/\n/)
      (0..a.size-2).each do | i |
        a[i] += "\n"
      end
      buf = a
    end
    @current = buf
    @current
  end

  def to_s
    @current.to_s
  end

  def to_a
    @current
  end

  # replace_all replaces all occurences matching +search+, where parentheses
  # define a regex replace wit substring. For example "(\\\\ruby\\{([^}]+)\\})"
  # will replace the whole match passing the substring contained between curly 
  # braces to the +replace_func+. This is repeated as long as there are matches.
  #
  # If +extra_parameters+ is defined the +replace_func+ is called with an 
  # array of extra matches
  #
  def replace_all search, replace_func, extra_parameters=0
    buf = to_s
    while pos = buf =~ /#{search}/
      orig = $1
      substr = $2
      extra = []
      (1..extra_parameters).each do | i |
        extra.push eval("$#{i+2}")
      end
      buf2 = ''
      if pos > 0 
        buf2 = buf[0..pos-1]
      end
      if extra_parameters == 0
        buf2 += replace_func.call(substr, orig)
      else
        buf2 += replace_func.call(substr, orig, extra)
      end
      if pos+orig.size < buf.size-2
        buf2 += buf[pos+orig.size..-1]
      end
      # print buf2
      # sleep 2
      buf = buf2
    end
    set(buf)  
    self
  end
end

if $UNITTEST

  class Test_Paragraph < Test::Unit::TestCase

    def test_buffer
      a = [ "with a single value representing the level of variation on each array.\n", "\n"]
      par = Paragraph.new(a)
      assert_equal(par.to_a,a)
      par.set(a)
      assert_equal(par.to_s,a.to_s)

      s = "line1\nline2 \n line3"
      par = Paragraph.new(s)
      assert_equal(s,par.to_s)
    end
  end

end
