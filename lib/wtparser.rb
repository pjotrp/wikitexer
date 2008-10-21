
require 'wikimedia/headers'
require 'wikimedia/basicformatting'
require 'wikimedia/ruby'
require 'types/paragraph'

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

