# These functions should really be generic and pass into a Writer module - 
# at the moment they are used by the HTML outputter to expand latex style
# functions

require 'output/html/htmlcreator'

module FormatterFunctions

  def ignore body
    ''
  end

  # The following functions should really be moved to the writer class
 
  def inserthtmltable filename
    insertfile filename,'<TABLE','<\/TABLE'
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

  def yellow body
    '<span style="background-color:yellow">'+body+'</span>'
  end 

  def mark body
    '<span style="background-color:yellow">'+body+'</span>'
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
    if $style[:final]
      bold(body)
    else
      '<span class="filename">'+body+'</span>'
    end
  end

  def format_var body
    if $style[:final]
      bold(body)
    else
      '<span class="varname">'+body+'</span>'
    end
  end

  def format_function body
    if $style[:final]
      bold(body)
    else
      '<span class="function">'+body+'</span>'
    end
  end

  def format_code body
    if $style[:final]
      bold(body)
    else
      '<span class="code">'+body+'</span>'
    end
  end

  def format_program body
    if $style[:final]
      bold(body)
    else
      '<span class="program">'+body+'</span>'
    end
  end

  def format_name body
    if $style[:final]
      bold(body)
    else
      '<span class="name">'+body+'</span>'
    end
  end

  def format_data body
    if $style[:final]
      bold(body)
    else
      '<span class="filename">'+body+'</span>'
    end
      '<span class="data">'+body+'</span>'
  end

  include HtmlGen
  def format_url body
    url2(body,body)
  end
end
