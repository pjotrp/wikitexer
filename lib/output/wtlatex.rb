
class WtLatex
  attr_reader :writer, :creator

  def initialize css
    @creator = LatexCreator.new
    @writer = LatexWriter.new css, @creator
  end

end
