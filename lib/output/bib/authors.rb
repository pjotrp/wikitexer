
module FormatBibAuthors

  def split_bib_authors list
    authors = []
    if list.kind_of?(String)
      strip_bibtex(list).split(/ and /).each do | s |
        authors.push s
      end
      authors
    else
      list
    end
  end

  def split_first_lastname s
    last,first = s.split(/,/,2)
    first = '' if first == nil
    return first,last
  end
end


