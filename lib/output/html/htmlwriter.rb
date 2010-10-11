
require 'tempfile'

class HtmlWriter

  def initialize css
    @css = css
  end

  def latex
    '<span class="latex">L<span class="a">A</span><span class="tex">T<span class="e">E</span>X</span></span>'
  end

  def tex
    '<span class="latex"><span class="tex">T<span class="e">E</span>X</span></span>'
  end

  def wikitexer
    'wiki'+tex+'er '+WIKITEXER_VERSION+' by Pjotr Prins'
  end

  def author
    author = ENV['USER']
    author = '<a href="http://thebird.nl/">pjotrp</a>' if author == 'wrk'
    author = 'unknown' if author == nil or author == ''
    author
  end

  def timestamp
    Time.now.strftime("%Y-%m-%d %H:%M")+' by '+author
  end

  def write buf
    print buf
  end

  def writeln buf
    print buf + "\n"
  end

  def tagbox text
    write "<div class=\"source-header\">"
    write text.capitalize
    write "</div>"
  end

  def code_box paragraph, env, lang=nil
    lang = env if lang == nil
    write "<div class=\"source\">\n"
    write "<div class=\"#{lang}\">\n"
    tagbox env
    Tempfile.open("wikitexer") do | f |
      paragraph.each { | line | f.print line }
      f.close
      write `/usr/bin/source-highlight -s #{lang} -i #{f.path}`
    end
    # paragraph.each { | line | write line }
    write "</div>\n"
    write "</div>\n"
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
      when 'quote'
        write "<div class=\"quote\">"
        paragraph.each { | line | write line }
        write "</div>"
      when 'quotation'
        write "<div class=\"quotation\">"
        paragraph.each { | line | write line }
        write "</div>"
      when 'cmake'
        code_box paragraph, last_env, 'shell'
      when 'perl' 
        code_box paragraph, last_env
      when 'python' 
        code_box paragraph, last_env
      when 'c' 
        code_box paragraph, last_env
      when 'swig'
        code_box paragraph, last_env, 'c'
      when 'r'
        code_box paragraph, last_env, 'slang'
      when 'ruby'
        code_box paragraph, last_env
      when 'shell'
        code_box paragraph, last_env
    else
      paragraph.each do | line |
        write line
        # write '<br />' if environments.has?('verbatim')
      end
    end
  end

  def header
    write "<html>\n"
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
    h1,h2,h3 { font-family: palatino font, monospace; color:darkblue;background-color:#F0F8FF; }
    body {font-family:'times new roman',times,serif; color:#222222;background-color:#F0F8FF; }
    div.verbatim { color:#8B0000; background-color: #D8BFD8; border-style:outset; }
    div.quote { font-family: palatino font, monospace; font-size:80%; }
    div.quotation { font-family: palatino font, monospace; font-size:80%; }
    div.source-header { text-align:right; color:blue; background-color:#CCCCFF; }
    div.source-author { text-align:right; background-color:white; }
    div.source { color: black; background-color:white ; border-style:outset; }
    div.ruby { color: black; background-color:#FFCCFF; ; border-style:outset; }
    div.python { color: black; background-color:#CCFFFF; ; border-style:outset; }
    div.r { color: black; background-color:#CCFFFF; ; border-style:outset; }
    div.perl { color: black; background-color:#CAFFD8; ; border-style:outset; }
    div.shell { color: black; background-color:white; ; border-style:outset; }
    span.filename { font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.varname { color: darkblue; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.function { color: darkblue; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.code { color: darkblue; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.program { color: darkgreen; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.name { color: darkred; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    span.data { color: darkgreen; font-family: palatino font, monospace; font-size:80%;  font-weight:bold; }
    .tex { font-family: Times, serif; letter-spacing: -0.09em; }
    span.latex{ font-family: Times, serif; letter-spacing: -0.3em; }
    span.tex .e { position:relative; top: 0.40ex; left: -0.01em; }
    span.latex .a { position: relative; bottom: 0.5ex; left: -0.1em; font-size: 75%; }
    /*]]>*/
    </style>
HEADER2
    end
    writeln "  <body>"
    write "<div class=\"source-author\">"
    write timestamp
    writeln "</div>"
  end

  def footer
    write "  <hr \>\n"
    writeln "  "+wikitexer+' - generated '+timestamp
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
