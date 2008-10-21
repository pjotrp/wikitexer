
class Paragraph

  attr_accessor :hastitle

  def initialize par
    @original = par.clone
    @current  = par
    hastitle = false
  end

  def set buf
    @current = buf
  end

  def to_s
    @current.to_s
  end

  def replace_all search, modifier = nil
    buf = to_s
    while pos = buf =~ /#{search}/
      repl = $1
      substr = $2
      buf2 = ''
      if pos > 0 
        buf2 = buf[0..pos-1]
      end
      buf2 += modifier.call(substr)
      if pos+repl.size < buf.size-2
        buf2 += buf[pos+repl.size..-1]
      end
      # print buf2
      # sleep 2
      buf = buf2
    end
    set(buf)  
    self
  end
end
