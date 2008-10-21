
require 'wikimedia/headers'
require 'types/paragraph'

class WtParser

  def initialize handler
    @handler = handler
  end

  def parse par
    generate = @handler.creator
    paragraph = Paragraph.new(par)    
    Headers::parse(paragraph, proc {|level,buf| generate.title(level,buf) } )
    w = @handler.writer
    w.start_par(paragraph)
    w.write paragraph
    w.end_par(paragraph)
  end

end

