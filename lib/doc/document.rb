
require 'doc/titlenumbering'
require 'doc/citations'
require 'doc/functionresolver'
require 'doc/environment/environmentstack'

# Keeps track of the document state

class Document

  attr_reader :titlenumbering, :citations, :functionresolver, :environments

  def initialize
    @titlenumbering   = TitleNumbering.new
    @citations        = Citations.new
    @functionresolver = FunctionResolver.new
    @environments      = EnvironmentStack.new
  end

  # Every input line passes through the +scan+ method to scan for 
  # environments. When and environment is found it updated on the
  # EnvironmentStack. This method returns the string stripped from its
  # environment commands
  def scan parser, s
    parser.parse_environments(@environments, s)
  end
end
