class QuoteService
  class LoginError < StandardError
  end

  class NotImplementedError < StandardError
  end

  # Login to the Stock Quote Service.  Raises a LoginError if the name
  # and/or password are invalid.
  def login(name, password)
    raise NotImplementedError
  end

  # Returns the current value of the given stock
  def quote(name)
    raise NotImplementedError
  end

  # Logout of the Stock Quote Service
  def logout
    raise NotImplementedError
  end
end
