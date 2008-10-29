
require 'doc/citations'

module CitationFunctions

  def cite document, body
    reference = document.citations.ref(body)
    format_cite(reference)
  end
end
