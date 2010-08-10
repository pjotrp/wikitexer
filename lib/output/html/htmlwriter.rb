
class HtmlWriter

  def initialize css
    @css = css
  end

  def write buf
    print buf
  end

  def write_paragraph environments, paragraph
    paragraph.each do | line |
      write line
      # write '<br />' if environments.has?('verbatim')
    end
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
    else
      write <<HEADER2
    <style type="text/css" media="all">
    /*<![CDATA[*/
    /* CSS inserted by theme options */
    body{font-family:'times new roman',times,serif;font-size:90%;color:#222222;background-color:#F0F8FF}
    body pre { margin: 3em 200px 0 0;color:#8B0000; background-color: #D8BFD8; border-style:outset; }
    /*]]>*/
    </style>
HEADER2
    end
  end

  def footer
    write "  <hr \>\n"
    write "  "+WIKITEXER_VERSION+' - generated '+Time.now.strftime("%Y-%m-%d %H:%M")+"\n"
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
