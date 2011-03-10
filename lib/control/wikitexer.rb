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
    # Check for environments, and update the env stack (should)
    s, last_env = @document.scan(@parser,s)
    # add line to paragraph
    @par.push s
    # if it is a full paragraph write it out, and empty @par
    write_paragraph(last_env) if s.strip.size == 0
  end

  def write_paragraph last_env
    # Here a paragraph gets transformed - unfortunately the environment
    # stack is empty here, last_env only contains last.
    # $stderr.print last_env,"\n"
    paragraph, env = @parser.parse_paragraph(@document,@par,last_env)
    @writer.start_par(paragraph)
    @writer.write_paragraph(env, @document.environments, paragraph)
    @writer.end_par(paragraph)
    @par = []
  end

  def add_reference ref
    @document.references[ref.key] = ref
  end

  def write_bibliography(style)
    @writer.bibliography(@writer,style,@document.citations, @document.references)
  end
end
