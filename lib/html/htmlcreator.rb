
class HtmlCreator

  def title level, buf
    if buf.strip.size > 0
      "<h#{level}>"+buf+"</h#{level}>"
    else
      buf
    end
  end

end


