
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

  def percentage buf
    '%'
  end

  def url buf
    a = buf.split
    if a.size != 2
      return '(<u>'+buf+'</u>)'
    end
    '<a href="' + a[0] + '">'+a[1]+'</a>'
  end
end


