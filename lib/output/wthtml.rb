
require 'output/html/htmlcreator'
require 'output/html/htmlwriter'

# WikiTeXer HTML output handler
#
class WtHtml

  attr_reader :writer, :creator

  def initialize css
    @creator = HtmlCreator.new
    @writer = HtmlWriter.new css, @creator
  end

end
