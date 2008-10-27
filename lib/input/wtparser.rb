
require 'input/wikimedia/headers'
require 'input/wikimedia/basicformatting'
require 'input/wikimedia/ruby'
require 'input/wikimedia/urlformatting'
require 'input/tex/functions'
require 'doc/paragraph'

# The main paragraph parser 
#
class WtParser

  def initialize creator
    @creator = creator
  end

  def parse document, par
    paragraph = Paragraph.new(par)
    # ---- remarks
    BasicFormatting::remarks(paragraph, @creator)
    # ---- Parse \ruby{}
    Ruby::parse(paragraph)
    # ---- expand functions
    Functions::expand(paragraph, document.functionresolver)
    # ---- titles
    Headers::markup(document, paragraph, proc {|titlenumber,level,buf| @creator.title(titlenumber,level,buf) } )
    # ---- urls
    UrlFormatting::markup(paragraph, @creator)
    # ---- standard markup
    BasicFormatting::markup(paragraph, @creator)
    paragraph
  end

end

