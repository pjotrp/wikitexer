# Citation tracker

class Citations

  def initialize
    @counter = 0
    @citations = {}
  end

  def ref cite
    if @citations[cite] == nil
      @counter += 1
      @citations[cite] = @counter
    end
    @citations[cite].to_s
  end

  def each 
    @citations.sort{|a,b| a[1]<=>b[1]}.each { |elem|
      yield elem[1], elem[0]
    }
  end
end
