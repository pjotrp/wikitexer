# Main WikiTeXer module which receives input lines through +addline+

class WikiTexer

  def initialize(parser, writer)
    @parser = parser
    @writer = writer
    @par = []  
  end

  # Assemble a paragraph from incoming lines and invoke the reader to
  # parse the incoming stream
  #
  def addline s, lineno, fn
    @par.push s
    if s.strip.size == 0
      paragraph = @parser.parse(@par)
      @writer.start_par(paragraph)
      @writer.write paragraph
      @writer.end_par(paragraph)
      @par = []
    end
  end

end
