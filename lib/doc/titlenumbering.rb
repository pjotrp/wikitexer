


class TitleNumbering

  attr_reader :level

  def initialize
    @level = [ 1 ]
  end

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

  def to_s
    @level.join('.')
  end
end

if $UNITTEST

  class Test_TitleNumbering < Test::Unit::TestCase

    def test_titelnum
      t = TitleNumbering.new
      assert_equal([1],t.level)
      t.newlevel
      assert_equal([1,1],t.level)
      t.bump
      assert_equal([1,2],t.level)
      t.bump
      assert_equal([1,3],t.level)
      assert_equal('1.3',t.to_s)
      t.parentlevel
      assert_equal('2',t.to_s)

    end
  end

end
