
class HtmlCreator

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

  def verbatim_start
    # "<pre>\n<![CDATA[\n"
    "\n<pre>\n"
  end

  def verbatim_end
    # "]]>\n</pre>"
    "\n</pre>\n"
  end

  def literal_start name
    "<#{name}>"
  end

  def literal_end name
    "</#{name}>"
  end

  def percentage buf
    '%'
  end

  def url buf
    a = buf.split(/ /,2)
    if a.size != 2
      return '(<u>'+buf+'</u>)'
    end
    '<a href="' + a[0] + '">'+a[1]+'</a>'
  end

  def keyword buf
    "<font color='RED'>"+bold(buf)+"</font>"
  end
end


