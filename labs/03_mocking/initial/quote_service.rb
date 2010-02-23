class QuoteService
  class LoginError < StandardError
  end

  class NotImplementedError < StandardError
  end

  def login(name, password)
    raise NotImplementedError
  end

  def quote(name)
    raise NotImplementedError
  end

  def logout
    raise NotImplementedError
  end
end
