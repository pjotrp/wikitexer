
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
    write "<p>\n" if !paragraph.hastitle
  end

  def end_par paragraph
    write "</p>\n" if !paragraph.hastitle
  end

end
