#!/usr/bin/env ruby
# -*- ruby -*-

require 'test/unit'

class SomeTest < Test::Unit::TestCase
  ('a'..'z').each do |letter|
    class_eval %{
      def test_#{letter}
        assert true
      end
    }
  end
end
