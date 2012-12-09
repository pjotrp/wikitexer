
module DraftModeFormatting

  # Replace special markup with appropriate output - e.g. highlight FIXME
  def DraftModeFormatting::markup paragraph, creator
    if not $style[:final]
      # highlight first sentence
      paragraph.replace_once('^(([\w\']+\s[^\.]+\.))', proc { | buf, orig | creator.highlight(buf) } )
      # Mark large numbers
      paragraph.replace_once('(((\d\d\d\d)\s))', proc { | buf, orig | creator.correct(buf) } )
      # don't use a comma before because
      paragraph.replace_once('((,\s+(without|because|while|partly)))', proc { | buf, orig | creator.correct(buf) } )
      # use a comma after i.e. and e.g.
      paragraph.replace_once('((\s+(i\.e\.|e\.g\.)\s))', proc { | buf, orig | creator.correct(buf) } )
      # use punctuation inside quotes
      paragraph.replace_once('((([\'"].)\s))', proc { | buf, orig | creator.correct(buf) } )
      # follow by a comma
      paragraph.replace_once('(((In addition|Likewise|Sometimes|Here|So far|For \w+)\s))', proc { | buf, orig | creator.correct(buf) } )
      # should have dash
      paragraph.replace_once('((\s(cross (language|platform)|(high|low) performance|\w+ level|\w+ sized|based)))', proc { | buf, orig | creator.correct(buf) } )
      # should have no dash
      paragraph.replace_once('((\s(open-source|web-service)))', proc { | buf, orig | creator.correct(buf) } )

      # use a comma before 'and'
      # paragraph.replace_once('(([^\,]\s+and))', proc { | buf, orig | creator.markword(buf) } )
    end
    paragraph
  end
end

