
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
    Headers::parse(paragraph, proc {|level,buf| @creator.title(level,buf) } )
    BasicFormatting::parse(paragraph,@creator)
    paragraph
  end

end

