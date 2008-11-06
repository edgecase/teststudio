# RubyJava - A Ruby/Java Bridge

module System
  def self.println(*args)
    puts(*args)
  end

  def self.out
    self
  end
end

class Object
  alias mm method_missing
  def method_missing(sym, *args, &block)
    new_sym = sym.to_s
    if new_sym =~ /[A-Z]/
      new_sym = rava_case(new_sym)
      send(new_sym, *args, &block)
    else
      mm(sym, *args, &block)
    end
  end

  def rava_case(string)
    string.gsub(/([A-Z]+[a-z]*)/) { |m| "_" + m.downcase }
  end

  private
  def new(klass, *args)
    klass.new(*args)
  end
end
