
require 'doc/titlenumbering'
require 'doc/citations'
require 'doc/functionresolver'

# Keeps track of the document state

class Document

  attr_reader :titlenumbering, :citations, :functionresolver

  def initialize
    @titlenumbering   = TitleNumbering.new
    @citations        = Citations.new
    @functionresolver = FunctionResolver.new
  end

end
