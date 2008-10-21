
require 'html/htmlcreator'
require 'html/htmlwriter'

class WtHtml

  attr_reader :writer, :creator

  def initialize css
    @creator = HtmlCreator.new
    @writer = HtmlWriter.new css
  end


end
