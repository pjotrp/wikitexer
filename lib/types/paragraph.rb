
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

end
