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
    # Check for environments
    s = @document.scan(@parser,s)
    @par.push s
    write_paragraph if s.strip.size == 0
  end

  def write_paragraph
    # Here a paragraph gets transformed - unfortunately the environment
    # stack is empty here
    paragraph = @parser.parse_paragraph(@document,@par)
    @writer.start_par(paragraph)
    @writer.write_paragraph @document.environments, paragraph
    @writer.end_par(paragraph)
    @par = []
  end

  def write_bibliography
    @writer.bibliography(@document.citations)
  end
end
