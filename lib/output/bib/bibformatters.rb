
module BibFormatter

  def BibFormatter::get_formatter writer, style
    case style[:format]
      when :nrg
        BibNRGFormatter.new(writer, style)
      when :springer
        BibSpringerFormatter.new(writer, style)
      else
        BibDefaultFormatter.new(writer, style)
    end
  end
end

class BibAuthor
  attr_accessor :surname, :initials
  def initialize name
    @surname = name
  end
  
  def to_s
    @surname
  end
end

module BibOutput

  # Authors in bibtex style are separated by 'and' keywords. Valid 
  # names are
  #
  #   Jane Austen 
  #   J. Austen
  #   Austen, Jane
  #   Austen, J.
  #
  # The output style can be any of these: firstnamefirst, initialsfirst,
  # firstnamelast, initialslast.
  #
  def authors authorstr, style = {}
    authors = []
    strip_bibtex(authorstr).split(/ and /).each do | s |
      # authors.push(BibAuthor.new(s))
      authors.push s
    end
    num = authors.size
    max=5
    max=style[:max_authors] if style[:max_authors]
    if style[:etal] and num > max
      aunum = 1
      aunum = style[:etal_num] if style[:etal_num]
      text = comma(authors[0..aunum-1].join(', '))
      text += if style[:etal] == :plain
        ' et al.'
      else
        ' <i>et al.</i>'
      end

    else
      if num > 1
        text = comma(authors[0..num-2].join(', ')+' &amp; '+authors[num-1])
      else
        text = comma(authors[0])
      end
    end
  end

  def url doi, link, full = false
    if doi and doi != ''
      text = '[DOI]'
      text = doi if full
      " <a href=\"http://dx.doi.org/#{doi}\">#{text}</a>"
    elsif link and link != ''
      text = '[Link]'
      text = link if full
      " <a href=\"#{link}\">#{text}</a>"
    else
      ''
    end
  end

  def citations bib
    text = ' <small>('
    if bib.has?(:Impact)
      text += "Impact factor = #{bold(bib[:Impact])}"
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
      text += "Cited "+cited.chop
    end
    text+')</small>'
  end

  def strip_bibtex str
    str.gsub!(/^\{/,'')
    str.gsub!(/\}$/,'')
    # $stderr.print str
    str
  end

  def bold str
    return @writer.creator.bold(str) if str!=nil and str.strip != ''
    ''
  end

  def italic str
    return @writer.creator.italics(str) if str!=nil and str.strip != ''
    ''
  end

  def comma str
    if str!=nil and str.strip != ''
      return str + ', '
    end
    ""
  end

  def dot str
    if str!=nil and str.strip != ''
      return str + '. '
    end
    ""
  end
end

module BibDefaultOutput

  def cite_marker num
    @writer.creator.superscript(num.to_s)
  end

  def reference_marker num
    # @writer.creator.superscript(num.to_s)
    "#{num.to_s}."
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

class BibDefaultFormatter
  include BibOutput
  include BibDefaultOutput

  def initialize writer, style
    @writer = writer
    @style = style
  end
  
end

class BibNRGFormatter
  include BibOutput
  include BibDefaultOutput

  def initialize writer, style
    @writer = writer
    @style = style
  end

  def reference_marker num
    @writer.creator.superscript(num.to_s)
  end

  def write bib
    text = authors(bib[:Author], :etal=>1, :amp=>true)
    if bib.type == 'book' or bib.type == 'incollection' or bib.type == 'inproceedings'
      text += strip_bibtex(comma(italic(bib[:Title])))+comma(bib[:Booktitle])+comma(bib[:Publisher])+bib[:Pages]+" (#{bib[:Year]})."
    else
     
      text += comma(strip_bibtex(bib[:Title]))+comma(italic(bib[:Journal]))+comma(bold(bib[:Volume]))+"#{bib[:Pages]} (#{bib[:Year]})."
    end
    if !@style[:final]
      text += url(bib[:Doi],bib[:Url])
      text += citations(bib) 
    end
    text
  end
end

class BibSpringerFormatter
  include BibOutput
  include BibDefaultOutput

  def initialize writer, style
    @writer = writer
    @style = style
    style[:max_authors] ||= 2
  end

  def cite_marker num
    @writer.creator.bold(@writer.creator.italics("(#{num.to_s})"))
  end

  def write bib
    text = authors(bib[:Author], :etal=>:plain, :etal_num => 2, :amp=>true)
    text += " (#{bib[:Year]}) "
    if bib.type == 'book' or bib.type == 'incollection' or bib.type == 'inproceedings'
      text += strip_bibtex(comma(italic(bib[:Title])))+comma(bib[:Booktitle])+comma(bib[:Publisher])+bib[:Pages]+"."
    else
     
      text += dot(strip_bibtex(bib[:Title]))+dot(bib[:Journal])+comma(bold(bib[:Volume]))+"#{bib[:Pages]}."
    end
    text += url(bib[:Doi],bib[:Url],true)
    if !@style[:final]
      text += citations(bib) 
    end
    text
  end
end

