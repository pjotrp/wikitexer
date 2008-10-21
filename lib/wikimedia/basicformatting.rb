
module BasicFormatting

  def BasicFormatting::parse paragraph, creator
    paragraph.replace_all("(''([^']+)'')", proc { | buf | creator.italics(buf) } )
  end

end
