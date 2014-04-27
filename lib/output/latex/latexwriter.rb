
require 'tempfile'
require 'output/bib/bibformatters'

class LatexWriter

  attr_accessor :style, :creator
  def initialize style, creator
    @style = style
    @creator = creator
  end

  def writer_name
    'LaTeX'
  end

  def latex
    '\LaTeX'
  end

  def tex
    '\TeX'
  end

  def wikitexer
    # 'wiki'+tex+'er '+WIKITEXER_VERSION+' by Pjotr Prins'
  end

  def author
    author = ENV['USER']
    author = 'pjotrp' if author == 'wrk'
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
    # write "<div class=\"source-header\">"
    write text.capitalize
    # write "</div>"
  end

  def code_box paragraph, env, lang=nil
    lang = env if lang == nil
    # write "<div class=\"source\">\n"
    # write "<div class=\"#{lang}\">\n"
    # tagbox env
    # Tempfile.open("wikitexer") do | f |
    #   paragraph.each { | line | f.print line }
    #   f.close
    #   code = `/usr/bin/source-highlight -s #{lang} -i #{f.path}`
    #   code = code.gsub(/<!--(.*?)-->[\n]?/m, "")
    #   if $style[:final]
    #     code = code.gsub(/<font color="#\w+">/, "<b>")
    #     code = code.gsub(/<\/font>/, "</b>")
    #   end
    # write code
    # end
    writeln '\begin{verbatim}'
    paragraph.each { | line | write line }
    writeln '\end{verbatim}'
    # write "</div>\n"
    # write "</div>\n"
  end
 
  # Writes a paragraph to stdout. When last_env contains a special 
  # environment, more can be done.
  def write_paragraph last_env, environments, paragraph
    # $stderr.print last_env,",",paragraph,"\n" if last_env != nil
    case last_env
      when 'listing'
        writeln '\begin{listing}'
        paragraph.each { | line | write line }
        writeln '\end{listing}'
      when 'verbatim'
        writeln '\begin{verbatim}'
        paragraph.each { | line | write line }
        writeln '\end{verbatim}'
      when 'quote'
        writeln '\begin{verbatim}'
        paragraph.each { | line | write line }
        writeln '\end{verbatim}'
      when 'quotation'
        writeln '\begin{verbatim}'
        paragraph.each { | line | write line }
        writeln '\end{verbatim}'
      when 'cmake'
        code_box paragraph, last_env, 'shell'
      when 'perl' 
        code_box paragraph, last_env
      when 'scala' 
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
    write <<DOC_HEADER
DOC_HEADER

    if @style
      write <<HEADER
HEADER
    else
      if $style[:final]
        write <<HEADER2
HEADER2
      else
        write <<HEADER2
HEADER2
      end
    end
    writeln '\input{wtstyle}'
    writeln '\begin{document}'
    # write   '\hfill '
    # writeln timestamp
  end

  def footer
    if !$style[:final]
      # write "  <hr \>\n"
      # writeln "  "+wikitexer+' - generated '+timestamp
    end
    # write "  </body>\n</latex>\n"
    write   '\end{document}'
  end

  def start_par paragraph
    write "\n" if !paragraph.hastitle
  end

  def end_par paragraph
    write "\n" if !paragraph.hastitle
  end

  def bibliography writer, style, citations, references
    # if citations.size == 0
    #   $stderr.print "No citations found" <- does not work because bibtex parses its own
    # else
      writeln '\bibliography{bibliography,../bibliography/thesis,../bibliography/bibliography}{}'
      writeln '\bibliographystyle{plain}'
    # end
  end

  def filename buf
    @creator.bold(buf)
  end

  def name buf
    @creator.bold(buf)
  end

  def code buf
    @creator.bold(buf)
  end

  def mark buf
    @creator.color("yellow",buf)
  end

end
