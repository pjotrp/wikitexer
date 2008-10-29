
class HtmlWriter

  def initialize css
    @css = css
  end

  def write buf
    print buf
  end

  def header
    write "<html>\n"
    write "  <body>\n"
    if @css
      write <<HEADER
    <head>
      <link href="#{@css}" rel="stylesheet" type="text/css">
    </head>
HEADER
    end
  end

  def footer
    write "  </body>\n</html>\n"
  end

  def start_par paragraph
    write "\n<p>\n" if !paragraph.hastitle
  end

  def end_par paragraph
    write "\n</p>\n" if !paragraph.hastitle
  end

  def bibliography citations
    write "\n<hr>\n<h2>Biobliography</h2>\n"
    citations.each do | ref, citation |
      write "\n<sup>#{ref}</sup> #{citation}<br />\n"
    end
  end
end
