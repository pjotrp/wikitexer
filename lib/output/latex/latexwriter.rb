
require 'tempfile'
require 'output/bib/bibformatters'

class LatexWriter

  attr_accessor :style, :creator
  def initialize style, creator
    @style = style
    @creator = creator
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
      code = `/usr/bin/source-highlight -s #{lang} -i #{f.path}`
      code = code.gsub(/<!--(.*?)-->[\n]?/m, "")
      if $style[:final]
        code = code.gsub(/<font color="#\w+">/, "<b>")
        code = code.gsub(/<\/font>/, "</b>")
      end
      write code
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
\\documentclass[a4paper,12pt]{memoir}
% \\usepackage{xltxtra} % For using XeTeX within LaTeX
% \\usepackage{polyglossia} % Babel replacement for XeTeX
% \\usepackage[style=apa,hyperref]{biblatex} % For reference management
% \\usepackage[pdfusetitle]{hyperref} % Creates hyperlinks and index in the PDF document, preferably load after biblatex
% \\usepackage{graphicx} % Required for inserting images
% \\usepackage{pgfplots} % Required for inserting graphs
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
    writeln '\begin{document}'
    # writeln "  <body>"
    # write "<div class=\"source-author\">"
    write timestamp
    # writeln "</div>"
  end

  def footer
    if !$style[:final]
      # write "  <hr \>\n"
      # writeln "  "+wikitexer+' - generated '+timestamp
    end
    # write "  </body>\n</latex>\n"
    write "\\end{document}"
  end

  def start_par paragraph
    write "\n\n" if !paragraph.hastitle
  end

  def end_par paragraph
    write "\n\n" if !paragraph.hastitle
  end

   				# #<Bibtex::Entry:0xb7c5b9f0 @fields={
	  			#   :Title=>#<Bibtex::Field:0xb7c591dc @value="Patterns for parallel programming", @key=:Title>, 
		  		#   :Year=>#<Bibtex::Field:0xb7c57f1c @value="2004", @key=:Year>, :Isbn=>#<Bibtex::Field:0xb7c578c8 @value="0321228111", @key=:Isbn>, 
			  	#   :Publisher=>#<Bibtex::Field:0xb7c57274 @value="Addison-Wesley Professional", @key=:Publisher>, 
				  #   :Author=>#<Bibtex::Field:0xb7c5b7c0 @value="Mattson, Timothy and Sanders, Beverly and Massingill, Berna", @key=:Author>}, 
				  #   @key="Mattson", @type="book">

  def bibliography writer, style, citations, references
    write "\n<hr>\n<h2>Bibliography</h2>\n"
    # $stderr.print references
    # p references
    bibformatter = BibFormatter::get_formatter(writer,style)
    citations.each do | ref, citation |
      text = citation
      if references[citation]
        # p references[citation]
        bib = references[citation]
        text = bibformatter.write(bib)
      end
      marker = bibformatter.reference_marker(ref)
      write "\n#{marker} #{text}<br />\n"
    end
  end

  def filename buf
    @creator.bold(buf)
  end

end
