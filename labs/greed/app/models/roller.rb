class Roller
  attr_reader :faces

  def initialize(source=RandomSource.new)
    @source = source
    @scorer = Scorer.new
  end

  def roll(n)
    @faces = random_faces(n)
    @scorer.score(@faces)
  end

  def points
    @scorer.points
  end

  def unused
    @scorer.unused
  end

  def new_score(existing_score)
    bust? ? 0 : existing_score + points
  end

  def bust?
    @scorer.points == 0
  end

  private

  def random_faces(n)
    @source.random_numbers(n)
  end
end
