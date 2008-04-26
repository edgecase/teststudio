class AnsiColors

  ATTRS = {
    :reset => 0,
    :bright => 1,
    :dim => 2,
    :underscore => 4,
    :blink => 5,
    :reverse => 7,
    :hidden => 8
  }    

  COLORS = {
    :black => 0,
    :red => 1,
    :green => 2,
    :yellow => 3,
    :blue => 4,
    :magenta => 5,
    :cyan => 6,
    :white => 7
  }
  COLOR_KEYWORDS = COLORS.keys

  FG = 30
  BG = 40

  def initialize(*keywords)
    vals = []
    color_mask = 30
    keywords.each do |key|
      case key
      when *COLOR_KEYWORDS
        vals << color_mask + COLORS[key]
        color_mask += 10
      else
        vals << ATTRS[key]
      end
    end
    @color_string = "\e[" + vals.join(';') + 'm'
  end

  def +(string)
    to_s + string.to_s
  end

  def to_s
    @color_string
  end

  def to_str
    to_s
  end
end

