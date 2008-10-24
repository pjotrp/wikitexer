
require 'input/wikimedia/headers'
require 'input/wikimedia/basicformatting'
require 'input/wikimedia/ruby'
require 'doc/paragraph'

# The main paragraph parser 
#
class WtParser

  def initialize creator
    @creator = creator
  end

  def parse par
    paragraph = Paragraph.new(par)
    Ruby::parse(paragraph)
    Headers::markup(paragraph, proc {|level,buf| @creator.title(level,buf) } )
    BasicFormatting::remarks(paragraph)
    paragraph
  end

end

