
module BibFormatter

  def BibFormatter::get_formatter writer, style
    case style[:format]
      when :nrg
        BibNRGFormatter.new(writer, style)
      else
        BibDefaultFormatter.new(writer, style)
    end
  end
end

module BibOutput

  def authors authorstr, style
    authors = strip_bibtex(authorstr).split(/ and /)
    if style[:etal] and authors.size > 5
      text = comma(authors[0..1].join(', ')+' <i>et al.</i>')
    else
      text = comma(authors.join(', '))
    end
  end

  def url doi, link
    if doi and doi != ''
      " <a href=\"http://dx.doi.org/#{doi}\">[DOI]</a>"
    elsif link and link != ''
      " <a href=\"#{link}\">[Link]</a>"
    else
      ''
    end
  end

  def citations bib
    text = ''
    if bib.has?(:Impact)
      text += " ; Impact factor = #{bold(bib[:Impact])}"
    end
    cited = ''
    if bib.has?(:Cited)
      cited += " #{bold(bib[:Cited])}x,"
    end
    if bib.has?(:Pmcited)
      cited += " Pubmed #{bold(bib[:Pmcited])}x,"
    end
    if bib.has?(:Gscited)
      cited += " Google Scholar #{bold(bib[:Gscited])}x,"
    end
    if cited != ''
      text += " ; Cited "+cited.chop
    end
    text
  end

  def strip_bibtex str
    str.gsub!(/^\{/,'')
    str.gsub!(/\}$/,'')
    # $stderr.print str
    str
  end

  def bold str
    return "<b>"+str+"</b>" if str!=nil and str.strip != ''
    ''
  end

  def italic str
    return "<i>"+str+"</i>" if str!=nil and str.strip != ''
    ''
  end

  def comma str
    if str!=nil and str.strip != ''
      return str + ', '
    end
    ""
  end
end

class BibDefaultFormatter
  include BibOutput

  def initialize writer, style
    @writer = writer
    @style = style
  end

  def write bib
    text = authors(bib[:Author],:etal=>true)
    if bib.type == 'book' or bib.type == 'incollection' or bib.type == 'inproceedings'
      text += strip_bibtex(comma(italic(bib[:Title])))+comma(bib[:Booktitle])+" #{bib[:Pages]} (#{bib[:Publisher]} #{bib[:Year]})."
    else
     
      text += comma(strip_bibtex(bib[:Title]))+comma(italic(bib[:Journal]))+comma(bold(bib[:Volume]))+"#{bib[:Pages]} [#{bib[:Year]}]."
    end
    if !@style[:final]
      text += url(bib[:Doi],bib[:Url])
      text += citations(bib) 
    end
    text
  end
end

class BibNRGFormatter
  include BibOutput

  def initialize writer, style
    @writer = writer
    @style = style
  end

end

