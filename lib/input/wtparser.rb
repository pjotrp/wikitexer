
require 'input/wikimedia/headers'
require 'input/wikimedia/basicformatting'
require 'input/wikimedia/ruby'
require 'input/wikimedia/urlformatting'
require 'input/wikimedia/listformatting'
require 'input/wikimedia/environmentformatting'
require 'input/support/keywordformatting'
require 'input/support/draftmodeformatting'
require 'input/tex/functions'
require 'doc/paragraph'

# The main paragraph parser 
#
class WtParser

  def initialize creator
    @creator = creator
  end

  # Parse a paragraph of this document and return the modified paragraph
  def parse_paragraph document, par, env
    paragraph = Paragraph.new(par)

    if env == nil
      is_indented, env = BasicFormatting::indented(paragraph, @creator)
      if !is_indented
        # ---- first remarks, so later HTML expansion does not break off
        BasicFormatting::remarks(paragraph, @creator)
        # ---- next urls, as we don't want expansion and to allow '[' expansion later
        UrlFormatting::markup(paragraph, @creator)
        # ---- parse \ruby{} and evaluate
        Ruby::parse(paragraph)
        # ---- expand bullets and lists
        ListFormatting::markup(paragraph, @creator)
        # ---- expand functions TeX style 
        Functions::expand(paragraph, document)
        # ---- some markup when in Draft mode
        DraftModeFormatting::markup(paragraph, @creator)
        # ---- create titles from wiki type markup
        Headers::markup(document, paragraph, proc {|titlenumber,level,buf| @creator.title(titlenumber,level,buf) } )
        # ---- standard wiki style markup (bold, italics etc.)
        BasicFormatting::markup(paragraph, @creator)
        # ---- special markup, for example highlighting FIXME
        KeywordFormatting::markup(paragraph, @creator) 
      end
    end
    return paragraph, env
  end

  # Parse line for environments and return the line stripped of markers, as well 
  # as the current environment (only one supported!)
  def parse_environments environments, line
    # temporary use a paragraph
    paragraph = Paragraph.new(line)
    paragraph, last_environment = EnvironmentFormatting::markup(paragraph, environments, @creator)
    # $stderr.print paragraph.to_string
    return paragraph.to_string+"\n", last_environment
  end

end

