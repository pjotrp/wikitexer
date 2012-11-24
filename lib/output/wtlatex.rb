
require 'output/latex/latexcreator'
require 'output/latex/latexwriter'

class WtLatex
  attr_reader :writer, :creator

  def initialize style
    @creator = LatexCreator.new
    @writer = LatexWriter.new style,@creator
  end

end
