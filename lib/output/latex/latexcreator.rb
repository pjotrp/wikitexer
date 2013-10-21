
module LatexGen

  def title titlenumbering, level, text
    if text.strip.size > 0
      # For LaTeX we ignore the numbering scheme
      names = %w{ chapter section subsection subsection paragragh subparagraph }
      name = names[level-1]
      '\\'+name+"{"+text+"}"
    else
      text
    end
  end

  def italics buf
    '\emph{'+buf+'}'
  end

  def bold buf
    '\textbf{'+buf+'}'
  end

  def small buf
    '\small{'+buf+'}'
  end

  def strikeout buf
    '?'+buf+'?'
  end

  def underline buf
    '?'+buf+'?'
  end

  def superscript buf
    '$^'+buf+'$'
  end

  def list_start buf
    '\begin{enumerate}' + buf + "\n"
  end

  def list_end buf
    buf + '\end{enumerate}' + "\n"
  end

  def bullets_start buf
    '\begin{itemize}' + buf + "\n"
  end

  def bullets_end buf
    buf + '\end{itemize}' + "\n"
  end

  def bullet buf
    '\item '+buf + "\n"
  end

  def listing_start
    '\begin{listing}'
  end

  def listing_end
    '\end{listing}'
  end


  def verbatim_start
    # "<pre>\n<![CDATA[\n"
    '\text{'
  end

  def verbatim_end
    # "]]>\n</pre>"
    "}"
  end

  def shell_start
    ''
  end

  def shell_end
    ''
  end

  def c_start
    ''
  end

  def c_end
    ''
  end

  def r_start
    ''
  end

  def r_end
    ''
  end

  def swig_start
    ''
  end

  def swig_end
    ''
  end

  def quote_start
    ''
  end

  def quote_end
    ''
  end

  def cmake_start
    ''
  end

  def cmake_end
    ''
  end

  def ruby_start
    ''
  end

  def ruby_end
    ''
  end

  def python_start
    ''
  end

  def python_end
    ''
  end

  def perl_start
    ''
  end

  def perl_end
    ''
  end

  def scala_start
    ''
  end

  def scala_end
    ''
  end

  def literal_start name
    "\\begin{#{name}}\n"
  end

  def literal_end name
    "\\end{#{name}}\n"
  end

  def url(buf, text=nil)
    a = if text==nil
          buf.split(/\s/,2)
        else
          a = [ buf, text ]
        end
    if a.size != 2
      return '(<u>'+buf+'</u>)'
    end
    link = if a[0] =~ /^search/
             "http://www.google.com/search?q="+a[1].gsub(/\s+/,"+")
           elsif a[0] !~ /:\/\/\w+\./ and a[0] !~ /\w+\.html/ and a[0] !~ /^\/\w+\//
             "http://"+a[0]
           else 
             a[0]
           end
    '<a href="' + link + '">'+a[1]+'</a>'
  end

  alias url2 url

  def keyword buf
    bold(buf)
  end

  def highlight buf
    '\highlight{'+buf+'}'
  end

  def markword buf
    bold(buf)
  end

  def correct buf
    bold(textcolor('red',buf))
  end

  def textcolor c, buf
    '{\color{'+c+'}{'+buf+'}}'
  end

  def color c, buf
    '\colorbox{'+c+'}{'+buf+'}'
  end
end

class LatexCreator
  include LatexGen
end
