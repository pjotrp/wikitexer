
module FileFunctions

  def insertfile filename
    IO.readlines(filename).to_s
  end

  def dummy arg='testDummy'
    arg
  end
end

