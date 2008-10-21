
module Headers

  # If a paragraph starts and ends with ='s it is a header
  #
  def Headers::parse paragraph, gen_title
    buf = paragraph.to_s.strip
    if buf =~ /^(=+)/
      level = $1.size
      if buf =~ /=+$/
        paragraph.hastitle = true
        # strip 
        buf = buf.sub(/^=+/,'')
        buf = buf.sub(/=+$/,'')
        paragraph.set(gen_title.call(level,buf.strip))
      end
    end
  end

end

