require 'doc/document'

# Main WikiTeXer module which receives input lines through +addline+

class WikiTexer

  def initialize(parser, writer)
    @parser = parser
    @writer = writer
    @document = Document.new
    @par = []  
  end

  # Assemble a paragraph from incoming lines and invoke the reader to
  # parse the incoming stream
  #
  def addline s, lineno, fn
    @par.push s
    write_paragraph if s.strip.size == 0
  end

  def write_paragraph
    paragraph = @parser.parse(@document,@par)
    @writer.start_par(paragraph)
    @writer.write paragraph
    @writer.end_par(paragraph)
    @par = []
  end
end
