
class Paragraph

  attr_accessor :hastitle

  def initialize par
    @original = par.clone
    @lines    = set(par)
    hastitle  = false
  end
 
  # Updates the paragraph buffer. Internally an Array - each item ending in an eol.
  def set buf
    @lines =  if buf.kind_of? String
                a = buf.split(/\n/)
                (0..a.size-2).each do | i |
                  a[i] += "\n"
                end
                a
              else
                buf.to_a
              end
    @lines
  end
  
  def set_line i, buf
    buf += "\n" if buf !~ /\n$/
    @lines[i] = buf
  end

  def to_s 
    raise "Nope, can not use this"
  end

  def to_string
    @lines.join
  end

  def [] i
    @lines[i]
  end

  def each 
    @lines.each do | s |
      yield s
    end
  end

  def to_a
    @lines
  end

  def size
    @lines.size
  end

  def replace_each_line_once search, replace_func
    @lines.each_with_index do | buf, index |
      if pos = buf =~ /#{search}/
        orig = $1
        substr = $2
        buf2 = ''
        if pos > 0 
          buf2 = buf[0..pos-1]
        end
        buf2 += replace_func.call(substr, orig)
        if pos+orig.size < buf.size-2
          buf2 += buf[pos+orig.size..-1]
        end
        buf = buf2+"\n"
        @lines[index] = buf
      end
    end
    self
  end

  # replace_all replaces all occurences matching +search+, where parentheses
  # define a regex replace with substring. For example "(\\\\ruby\\{([^}]+)\\})"
  # will replace the whole match passing the substring contained between curly 
  # braces to the +replace_func+. This is repeated as long as there are matches.
  #
  # If +extra_parameters+ is defined the +replace_func+ is called with an 
  # array of extra matches
  #
  def replace_all search, replace_func, extra_parameters=0
    buf = to_string
    while pos = buf =~ /#{search}/
      # OK, we have a match
      orig = $1
      substr = $2
      extra = []
      # Check whethe we have extra parameters to this function, defined
      # by regexs in braces ...(1)...(2)...(3)...
      (1..extra_parameters).each do | i |
        extra.push eval("$#{i+2}")
      end
      buf2 = ''
      if pos > 0 
        # store the prefix
        buf2 = buf[0..pos-1]
      end
      # now invoke the lambda using the function name and parameters
      if extra_parameters == 0
        buf2 += replace_func.call(substr, orig)
      else
        buf2 += replace_func.call(substr, orig, extra)
      end
      # orig.size is the replacement size
      # buf.size is the original buffer
      if pos+orig.size <= buf.size-1
        # store the postfix
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
      assert_equal(a.join,par.to_string)

      s = "line1\nline2 \n line3"
      par = Paragraph.new(s)
      assert_equal(s,par.to_string)
    end
  end

end
