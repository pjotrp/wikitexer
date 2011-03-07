


class TitleNumbering

  attr_reader :level

  def initialize
    @level = [ 0 ]
  end

  # bump the last element
  def bump
    @level[-1] += 1
  end

  def newlevel
    @level.push 1
  end

  def parentlevel
    @level.pop
    bump
  end

  # both adjust level and bump
  def levelbumper level
    if level == @level.size
      bump
      return to_s
    end
    if level > @level.size
      while level > @level.size
        # p ['>',@level]
        newlevel
      end
      return to_s
    end
    while level < @level.size
      # p ['<',@level]
      parentlevel
    end
    to_s
  end

  def to_s
    if $bib_style and $bib_style[:format] == :springer
      @level[1..-1].join('.')
    else
      @level.join('.')
    end
  end
end

if $UNITTEST!=nil

  class Test_TitleNumbering < Test::Unit::TestCase

    def test_titelnum
      t = TitleNumbering.new
      assert_equal([0],t.level)
      t.bump
      t.newlevel
      assert_equal([1,1],t.level)
      t.bump
      assert_equal([1,2],t.level)
      t.bump
      assert_equal([1,3],t.level)
      assert_equal('1.3',t.to_s)
      t.parentlevel
      assert_equal('2',t.to_s)
      assert_equal('3',t.levelbumper(1))
      assert_equal('3.1',t.levelbumper(2))
      assert_equal('3.2',t.levelbumper(2))
      assert_equal('3.2.1',t.levelbumper(3))
      assert_equal('3.3',t.levelbumper(2))
      assert_equal('3.3.1.1',t.levelbumper(4))
      assert_equal('3.4',t.levelbumper(2))
    end
  end

end
