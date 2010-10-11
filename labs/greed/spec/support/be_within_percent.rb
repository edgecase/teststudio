
def be_within_percent(expected, percent)
  be_close(expected, expected * (percent/100.0))
end
