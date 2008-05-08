#!/usr/bin/env ruby
# -*- ruby -*-

require 'test/unit'

class SomeTest < Test::Unit::TestCase
  ('a'..'zzz').each do |letter|
    class_eval %{
      def test_#{letter}
        assert true
        sleep 0.25
      end
    }
  end
end
