
require 'doc/citations'

module CitationFunctions

  def cite document, body
    reference = document.citations.ref(body)
    has_reference = document.references[body]
    format_cite(reference,has_reference)
  end
end
