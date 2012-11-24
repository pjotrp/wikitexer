# These functions should really be generic and pass into a Writer module - 
# at the moment they are used by the HTML outputter to expand latex style
# functions

require 'output/html/htmlcreator'

module FormatterFunctions

  def ignore body
    ''
  end

end
