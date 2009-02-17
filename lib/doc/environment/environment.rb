# Environment object, keeps track of one environment. Each environment
# has three generators on the output side. start, finish and intermediate.

class Environment

  attr_reader :name

  def initialize name
    @name = name
  end

  def is? name
    name == @name
  end

end


