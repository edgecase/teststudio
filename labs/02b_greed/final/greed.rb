# Return the score of a greed roll.
def score(roll)
  score = 0
  counts = Hash.new { |h, k| h[k] = 0 }
  roll.each do |v| counts[v] += 1 end
  i = 1
  while i <= 6
    if i == 1 && counts[i] >= 3
      score += i * 1000
      counts[i] -= 3
    elsif counts[i] >= 3
      score += i * 100
      counts[i] -= 3
    elsif i == 1
      score += 100 * counts[i]
      counts[i] = 0
    elsif i == 5
      score += 50 * counts[i]
      counts[i] = 0
    else
      counts[i] = 0
    end
    i += 1 if counts[i] == 0
  end
  score
end
    
