
module DraftModeFormatting

  # Replace special markup with appropriate output - e.g. highlight FIXME
  def DraftModeFormatting::markup paragraph, creator
    if not $style[:final]
      # highlight first sentence
      paragraph.replace_once('^(([\w\']+\s[^\.]+\.))', proc { | buf, orig | creator.highlight(buf) } )
      # don't use a comma before because
      paragraph.replace_once('((,\s+(because|while|partly)))', proc { | buf, orig | creator.markword(buf) } )
      # use a comma before 'and'
      # paragraph.replace_once('(([^\,]\s+and))', proc { | buf, orig | creator.markword(buf) } )
    end
    paragraph
  end
end

