
class HtmlWriter

  def initialize css
    @css = css
  end

  def header
    print "<html>\n"
    print "  <body>\n"
    if @css
      print <<HEADER
    <head>
      <link href="#{@css}" rel="stylesheet" type="text/css">
    </head>
HEADER
    end
  end

  def footer
    print "  </body>\n</html>\n"
  end

end
