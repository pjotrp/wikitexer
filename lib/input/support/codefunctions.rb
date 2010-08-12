
module CodeFunctions

  def var varname
    format_var(varname)
  end

  def function s
    format_function(s)
  end

  def func s
    format_function(s)
  end

  def data source
    format_data(source)
  end

  def name source
    format_name(source)
  end

  def code source
    format_code(source)
  end

end

