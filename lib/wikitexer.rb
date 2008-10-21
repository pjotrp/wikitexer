# Main WikiTeXer module which receives input lines through +addline+

class WikiTexer

  def initialize(parser)
    @parser = parser
    @par = []  
  end

  # Assemble a paragraph from incoming lines and invoke the reader to
  # parse the incoming stream
  #
  def addline s, lineno, fn
    @par.push s
    if s.strip.size == 0
      @parser.parse(@par)
      @par = []
    end
  end

end
