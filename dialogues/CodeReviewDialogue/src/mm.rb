class Object
  def method_missing(sym, *args, &block)
    puts "Running #{sym}"
    super
  end
end
