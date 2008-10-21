
require 'html/htmlwriter'

class WtHtml

  attr_reader :writer

  def initialize css
    @writer = HtmlWriter.new css
  end


end
