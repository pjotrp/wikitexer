
module HtmlGen

  def title titlenumbering, level, buf
    if buf.strip.size > 0
      "<h#{level}>"+titlenumbering.to_s+' '+buf+"</h#{level}>"
    else
      buf
    end
  end

  def italics buf
    '<i>'+buf+'</i>'
  end

  def bold buf
    '<b>'+buf+'</b>'
  end

  def small buf
    '<SMALL>'+buf+'</SMALL>'
  end

  def strikeout buf
    '<S>'+buf+'</S>'
  end

  def underline buf
    '<U>'+buf+'</U>'
  end

  def superscript buf
    '<sup>'+buf+'</sup>'
  end

  def list_start buf
    '<ol>' + buf
  end

  def list_end buf
    buf + '</ol>'
  end

  def bullets_start buf
    '<ul>' + buf
  end

  def bullets_end buf
    buf + '</ul>'
  end

  def bullet buf
    '<li>'+buf  # +'</li>'
  end

  def bignum buf
    '<b>'+buf+'</b>'
  end

  def verbatim_start
    # "<pre>\n<![CDATA[\n"
    "<pre>"
  end

  def verbatim_end
    # "]]>\n</pre>"
    "</pre>"
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
    "<#{name}>"
  end

  def literal_end name
    "</#{name}>"
  end

  def percentage buf
    '&#37;'
  end

  def amp buf
    '&amp;'
  end

  def chi buf
    '&Chi;'
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
    "<font color='RED'>"+bold(buf)+"</font>"
  end

  def highlight buf
    italics(buf)
  end

  def correct buf
    bold(textcolor('red',buf))
  end

  def markword buf
    "<font color='GRAY'>"+bold(buf)+"</font>"
  end

  def textcolor c, buf
    color(c,buf)
  end

  def color c, buf
    "<font color='#{c}'>"+bold(buf)+"</font>"
  end
end

class HtmlCreator
  include HtmlGen
end
