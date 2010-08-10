
require 'tempfile'

class HtmlWriter

  def initialize css
    @css = css
  end

  def write buf
    print buf
  end

  def writeln buf
    print buf + "\n"
  end

  def tagbox text
    write "<div class=\"sourceheader\">"
    write text 
    write "</div>"
  end

  # Writes a paragraph to stdout. When last_env contains a special 
  # environment, more can be done.
  def write_paragraph last_env, environments, paragraph
    # $stderr.print last_env,",",paragraph,"\n" if last_env != nil
    case last_env
      when 'verbatim'
        write "<div class=\"verbatim\">"
        paragraph.each { | line | write line }
        write "</div>"
      when 'cmake'
        write "<pre>\n"
        tagbox last_env
        paragraph.each { | line | write line }
        write "</pre>\n"
      when 'perl' 
        write "<pre>\n"
        tagbox last_env
        paragraph.each { | line | write line }
        write "</pre>\n"
      when 'python' 
        write "<pre>\n"
        tagbox last_env
        paragraph.each { | line | write line }
        write "</pre>\n"
      when 'c' 
      when 'swig'
        write "<pre>\n"
        tagbox last_env
        paragraph.each { | line | write line }
        write "</pre>\n"
      when 'ruby' 
        write "<div class=\"source\">\n"
        tagbox last_env
        Tempfile.open("wikitexer") do | f |
          paragraph.each { | line | f.print line }
          f.close
          write `/usr/bin/source-highlight -s ruby -i #{f.path}`
        end
        # paragraph.each { | line | write line }
        write "</div>\n"
      when 'shell'
        write "<div class=\"verbatim\">"
        write "<pre>\n"
        tagbox last_env
        paragraph.each { | line | write line }
        write "</pre>\n"
        write "</div>"
    else
      paragraph.each do | line |
        write line
        # write '<br />' if environments.has?('verbatim')
      end
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
    body {font-family:'times new roman',times,serif;font-size:90%;color:#222222;background-color:#F0F8FF}
    div.verbatim { color:#8B0000; background-color: #D8BFD8; border-style:outset; }
    div.sourceheader { text-align:right; color:blue; background-color:#CCCCFF; }
    div.source { color: black; background-color:#CCFFFF; ; border-style:outset; }
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
