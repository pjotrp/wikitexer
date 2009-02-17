# The environment stack keeps track of environments at a certain position of the
# document.
#
# The output generator polls the EnvironmentStack to see if there is a start of finish
# action for a certain environment. Also when processing it can poll to see if it is 
# inside a certain environment. Each environment may have properties - and the
# environments may be stacked inside each other. To test for overridden settings
# the stack is parsed backwards for properties.

require 'doc/environment/environment'

class EnvironmentStack

  def initialize
    @stack = []
  end

  def push environment
    @stack.push environment
  end

  def pop name
    environment = @stack.pop 
    raise 'Environment error - unbalanced environments' if environment.name != name
    environment
  end

  # Checks whether environment +name+ is on the stack
  def has? name
    @stack.each do | e |
      return true if e.name == name
    end
    false
  end
  # Parse the stack backwards until we find an environment property
  def get_property name, property
    each(name) do | e |
      p = e.call(property)
      return p if p != nil
    end
    nil
  end

  # Yield environments (backwards). Match +name+ if not nil.
  def each name=nil
    @stack.reverse_each do | e |
      next if name and name != e.name
      yield e
    end
  end

end

if $UNITTEST

  class Test_EnvironmentStack < Test::Unit::TestCase

    def test_stack
      s = EnvironmentStack.new
      s.push Environment.new('verbatim')
      assert(s.has?('verbatim'))
      s.pop('verbatim')
      assert(!s.has?('verbatim'))
    end

  end

end

