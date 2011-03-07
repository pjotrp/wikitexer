
module Headers

  # If a paragraph starts and ends with ='s it is a header
  #
  def Headers::markup document, paragraph, gen_title
    buf = paragraph.to_string.strip
    if buf =~ /^(=+)/
      level = $1.size
      if buf =~ /=+$/
        paragraph.hastitle = true
        # strip 
        buf = buf.sub(/^=+/,'')
        buf = buf.sub(/=+$/,'')
        document.titlenumbering.levelbumper(level)
        paragraph.set(gen_title.call(document.titlenumbering,level,buf.strip))
      end
    end
  end

end

