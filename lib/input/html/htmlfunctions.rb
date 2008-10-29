module HtmlFunctions

  def inserthtmltable filename
    insertfile filename,'<TABLE','<\/TABLE'
  end

  def remark body
    <<REMARK
    <table width='98%'><tr bgcolor='lightyellow'><td border=1 bgcolor='grey'>&nbsp;</td><td>
    #{body}
    </td></tr></table>
REMARK
  end

  def ref body
    '<u>'+body+'</u> section'
  end

  def format_cite body
    '<small><sup>'+body+'</sup></small>'

  end

end
