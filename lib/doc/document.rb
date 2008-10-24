
require 'doc/titlenumbering'

# Keeps track of the document state

class Document

  attr_reader :titlenumbering

  def initialize
    @titlenumbering = TitleNumbering.new
  end

end
