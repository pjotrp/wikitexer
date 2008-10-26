
require 'doc/titlenumbering'
require 'doc/functionresolver'

# Keeps track of the document state

class Document

  attr_reader :titlenumbering, :functionresolver

  def initialize
    @titlenumbering = TitleNumbering.new
    @functionresolver = FunctionResolver.new
  end

end
