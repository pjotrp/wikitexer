
module DraftModeFormatting

  # Replace special markup with appropriate output - e.g. highlight FIXME
  def DraftModeFormatting::markup paragraph, creator
    if not $style[:final]
      # highlight first sentence
      paragraph.replace_once('^(([^\.]+\.))', proc { | buf, orig | creator.highlight(buf) } )
    end
    paragraph
  end
end

