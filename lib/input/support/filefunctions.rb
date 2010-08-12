
module FileFunctions

  def insertfile filename, start=nil, stop=nil
    if !File.exist?(filename)
      $stderr.print "Warning: can not find file #{filename}!\n"
      return "\nMissing insertfile: '#{filename}'\n"
    else
      buf = ''
      File.open(filename) do | f |
        inside = false
        f.each_line do | line |
          inside = true if start==nil or (start and line =~ /#{start}/)
          if stop and line =~ /#{stop}/
            buf += line
            inside = false
          end
          buf += line if inside
        end
      end
    end
    buf
  end

  def fn filen
    format_filename(filen)
  end

  def dummy arg='testDummy'
    arg
  end
end

