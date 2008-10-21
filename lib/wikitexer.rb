# Main WikiTeXer module which receives input lines through +addline+

require 'wtlatex'
require 'wthtml'

class WikiTexer
  def initialize(outputtype)
    if outputtype==LATEX
      @generator = WtLatex.new
    elsif outputtype==HTML
      @generator = WtHtml.new
    else
      raise 'Unknown output type'
    end
  end
end
