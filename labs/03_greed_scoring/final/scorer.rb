class Scorer
  attr_reader :points, :unused

  def score(roll)
    @unused = 0
    @points = 0

    counts = count_sides(roll)
    counts.each do |face, count|
      while count > 0
        if count >= 3 && face == 1
          @points += 1000
          count -= 3
        elsif count >= 3
          @points += 100 * face
          count -= 3
        elsif face == 5
          @points += 50 * count
          count = 0
        elsif face == 1
          @points += 100 * count
          count = 0
        else
          @unused += count
          count = 0
        end
      end
    end
  end

  def count_sides(roll)
    result = Hash.new(0)
    (1..6).each do |face|
      result[face] += count_face(roll, face)
    end
    result
  end

  def count_face(roll, face)
    roll.select { |n| n == face }.size
  end
end
