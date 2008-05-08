#!/usr/bin/env ruby

require 'test/unit'
require 'ansi_colors'

class AnsiColorsTest < Test::Unit::TestCase
  def test_foreground_only
    assert_equal "\e[30m", AnsiColors.new(:black).to_s
    assert_equal "\e[31m", AnsiColors.new(:red).to_s
    assert_equal "\e[32m", AnsiColors.new(:green).to_s
    assert_equal "\e[33m", AnsiColors.new(:yellow).to_s
    assert_equal "\e[34m", AnsiColors.new(:blue).to_s
    assert_equal "\e[35m", AnsiColors.new(:magenta).to_s
    assert_equal "\e[36m", AnsiColors.new(:cyan).to_s
    assert_equal "\e[37m", AnsiColors.new(:white).to_s
  end

  def test_foreground_and_background
    assert_equal "\e[30;40m", AnsiColors.new(:black, :black).to_s
    assert_equal "\e[30;41m", AnsiColors.new(:black, :red).to_s
    assert_equal "\e[31;40m", AnsiColors.new(:red, :black).to_s
    assert_equal "\e[37;40m", AnsiColors.new(:white, :black).to_s
  end

  def test_attributes
    assert_equal "\e[0m", AnsiColors.new(:reset).to_s
    assert_equal "\e[1m", AnsiColors.new(:bright).to_s
    assert_equal "\e[2m", AnsiColors.new(:dim).to_s
    assert_equal "\e[4m", AnsiColors.new(:underscore).to_s
    assert_equal "\e[5m", AnsiColors.new(:blink).to_s
    assert_equal "\e[7m", AnsiColors.new(:reverse).to_s
    assert_equal "\e[8m", AnsiColors.new(:hidden).to_s

    assert_equal "\e[1;4m", AnsiColors.new(:bright, :underscore).to_s
  end

  def test_attributes
    assert_equal "\e[36;47;5m", AnsiColors.new(:cyan, :white, :blink).to_s
    assert_equal "\e[36;5;47m", AnsiColors.new(:cyan, :blink, :white).to_s
    assert_equal "\e[5;36;47m", AnsiColors.new(:blink, :cyan, :white).to_s
  end

  def test_conversion
    color = AnsiColors.new(:red)
    assert_kind_of String, color + ""
    assert_kind_of String, color + color
    assert_kind_of String, "" + color    
  end
end
