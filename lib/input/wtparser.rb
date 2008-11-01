
require 'input/wikimedia/headers'
require 'input/wikimedia/basicformatting'
require 'input/wikimedia/ruby'
require 'input/wikimedia/urlformatting'
require 'input/wikimedia/listformatting'
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
    # ---- first remarks, so later HTML expansion does not break off
    BasicFormatting::remarks(paragraph, @creator)
    # ---- next urls, as we don't want expansion and to allow '[' expansion later
    UrlFormatting::markup(paragraph, @creator)
    # ---- parse \ruby{}
    Ruby::parse(paragraph)
    # ---- expand bullets and lists
    ListFormatting::markup(paragraph, @creator)
    # ---- expand functions
    Functions::expand(paragraph, document)
    # ---- titles
    Headers::markup(document, paragraph, proc {|titlenumber,level,buf| @creator.title(titlenumber,level,buf) } )
    # ---- standard markup
    BasicFormatting::markup(paragraph, @creator)
    paragraph
  end

end

