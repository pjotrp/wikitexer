
class HtmlCreator

  def title level, buf
    if buf.strip.size > 0
      "<h#{level}>"+buf+"</h#{level}>"
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
end


