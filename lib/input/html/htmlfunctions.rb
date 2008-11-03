# These functions should really be generic and pass into a Creator module

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

  def textbox body
    <<TEXTBOX
    <table width='98%' border="1"><tr bgcolor='lightblue'><td border=1 bgcolor='black'>&nbsp;</td><td>
    #{body}
    </td></tr></table>
TEXTBOX
  end

  def ref body
    '<u>'+body+'</u> section'
  end

  def format_cite body
    '<small><sup>'+body+'</sup></small>'
  end

end
