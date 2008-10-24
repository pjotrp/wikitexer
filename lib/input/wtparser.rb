
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

  def parse document, par
    paragraph = Paragraph.new(par)
    Ruby::parse(paragraph)
    Headers::markup(document, paragraph, proc {|titlenumber,level,buf| @creator.title(titlenumber,level,buf) } )
    BasicFormatting::markup(paragraph, @creator)
    BasicFormatting::remarks(paragraph)
    paragraph
  end

end

