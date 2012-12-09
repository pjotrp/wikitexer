
module CodeFunctions

  def var varname
    @writer.var(varname)
  end

  def function s
    @writer.function(s)
  end

  def func s
    @writer.function(s)
  end

  def program source
    @writer.program(source)
  end

  def data source
    @writer.data(source)
  end

  def name source
    @writer.name(source)
  end

  def code source
    @writer.code(source)
  end

  def command source
    @writer.code(source)
  end

end

