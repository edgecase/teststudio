require 'test/unit'

module System
  def self.println(*args)
    puts(*args)
  end
  def self.out
    self
  end
end


module Kernel
  private
  def new(klass)
    klass.new
  end
end

class Object
  def method_missing(sym, *args, &block)
    new_sym = sym.to_s
    if new_sym =~ /[A-Z]/
      new_sym = rava_case(new_sym)
      send(new_sym, *args, &block)
    else
      super(sym, *args, &block)
    end
  end

  def rava_case(string)
    string.gsub(/([A-Z]+[a-z]*)/) { |m| "_" + m.downcase }
  end
end

require 'stringio'
module IoCapture
  def capture_out
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end

# used for test
class A ; end

class RavaTest < Test::Unit::TestCase
  include IoCapture

  def test_camel_case
    assert_equal "123", 123.toS
    assert_equal 123, "123".toI
  end

  def test_original_method_missing
    assert_raise(NoMethodError) do
      1.xyz
    end
  end

  def test_rava_case
    assert_equal "hello_world", rava_case("helloWorld")
    assert_equal "dal_read", rava_case("dalRead")
  end

  def test_system_out_println
    result = capture_out do
      System.out.println("Hello, World")
    end
    assert_equal "Hello, World\n", result
  end

  def test_new_method
    a = new A

    assert_not_nil a
    assert_instance_of A, a
  end

end
