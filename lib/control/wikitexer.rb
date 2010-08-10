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
    s, last_env = @document.scan(@parser,s)
    @par.push s
    write_paragraph(last_env) if s.strip.size == 0
  end

  def write_paragraph last_env
    # Here a paragraph gets transformed - unfortunately the environment
    # stack is empty here
    # $stderr.print last_env,"\n"
    paragraph = @parser.parse_paragraph(@document,@par)
    @writer.start_par(paragraph)
    @writer.write_paragraph(last_env, @document.environments, paragraph)
    @writer.end_par(paragraph)
    @par = []
  end

  def write_bibliography
    @writer.bibliography(@document.citations)
  end
end
