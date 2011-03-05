# These functions should really be generic and pass into a Creator module

require 'output/html/htmlcreator'

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

  def ignore body
    ''
  end

  def textbox body
    <<TEXTBOX
    <table width='98%' border="1"><tr bgcolor='lightblue'><td border=1 bgcolor='black'>&nbsp;</td><td>
    #{body}
    </td></tr></table>
TEXTBOX
  end

  def includegraphics body
    img = '<img src="'+body+'" />'
    img
  end

  def caption body
    '<small>'+body+'</small>'
  end

  def label body
    'Figure: '
  end

  def large body
    '<font size="8">'+body+'</font>'
  end

  def ref body
    '<u>'+body+'</u> section'
  end

  def format_emph body
    '<i>'+body+'</i>'
  end

  def format_cite body, resolved
    text = body
    if $bib_style[:format] == :springer
      text = '<font color="red">'+body+'</font>' if !resolved
      ' <b><i>('+text+')</i></b>'
    else
      text = '<u><font color="red">'+body+'</font></u>' if !resolved
      '<small><sup>'+text+'</sup></small>'
    end
  end

  def format_textsuperscript body
    '<small><sup>'+body+'</sup></small>'
  end

  def format_filename body
    '<span class="filename">'+body+'</span>'
  end

  def format_var body
    '<span class="varname">'+body+'</span>'
  end

  def format_function body
    '<span class="function">'+body+'</span>'
  end

  def format_code body
    '<span class="code">'+body+'</span>'
  end

  def format_program body
    '<span class="program">'+body+'</span>'
  end

  def format_name body
    '<span class="name">'+body+'</span>'
  end

  def format_data body
    '<span class="data">'+body+'</span>'
  end

  include HtmlGen
  def format_url body
    url2(body,body)
  end
end
