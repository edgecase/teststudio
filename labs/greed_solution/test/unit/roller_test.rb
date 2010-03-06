require 'test_helper'

class RollerTest < Test::Unit::TestCase
  context 'A roller' do
    setup do
      @roller = Roller.new
    end

    should 'roll n dice' do
      assert_equal 2, roll_size(2)
      assert_equal 5, roll_size(5)
    end

    should 'be randomly distributed' do
      collect_face_counts.each do |face, count|
        assert_tween 1, 6, face, "face"
        assert_tween 800, 1200, count, "count"
      end
    end

    context 'with a scoring roll' do
      setup do
        @roller = Roller.new(SimulatedData.new([[1, 5, 2, 3, 2]]))
      end

      should 'calculate the correct scores' do
        @roller.roll(5)
        assert_equal 150, @roller.points
        assert_equal 3, @roller.unused
        assert_equal 200, @roller.new_score(50)
      end
    end

    context 'with a non-scoring roll' do
      setup do
        @roller = Roller.new(SimulatedData.new([[4, 4, 2, 3, 2]]))
      end

      should 'calculate the correct scores' do
        @roller.roll(5)
        assert_equal 0, @roller.points
        assert_equal 5, @roller.unused
        assert_equal 0, @roller.new_score(50)
      end
    end
  end

  private

  def roll_size(n)
    @roller.roll(n)
    @roller.faces.size
  end

  def assert_tween(min, max, actual, name)
    assert actual >= min, "#{name} must be >= #{min} (was #{actual})"
    assert actual <= max, "#{name} must be <= #{max} (was #{actual})"
  end

  def collect_face_counts
    result = Hash.new { |h, k| h[k] = 0 }
    1200.times do
      @roller.roll(5)
      @roller.faces.each do |face|
        result[face] += 1
      end
    end
    result
  end
end
