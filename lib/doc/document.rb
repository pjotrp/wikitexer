
require 'doc/titlenumbering'
require 'doc/citations'
require 'doc/references'
require 'doc/functionresolver'
require 'doc/environment/environmentstack'

# Keeps track of the document state
class Document

  attr_reader :titlenumbering, :references, :citations, :functionresolver, :environments

  def initialize writer
    @titlenumbering   = TitleNumbering.new
    @citations        = Citations.new
    @references       = References.new
    @functionresolver = FunctionResolver.new(writer)
    @environments     = EnvironmentStack.new
    @parsing = true
  end

  # Every input line passes through the +scan+ method to scan for 
  # environments. When an environment is found it updated on the
  # EnvironmentStack. This method returns the string stripped from its
  # environment commands
  #
  # Note the stack is not working
  def scan parser, s
    parser.parse_environments(@environments, s)
  end

  def start_parsing 
    @parsing = true
  end
  def stop_parsing 
    @parsing = false
  end
  def parsing?
    @parsing
  end
end
