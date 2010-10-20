#!/usr/bin/env ruby

def classify_triangle(a, b, c)
  a, b, c = [a,b,c].sort
  fail ArgumentError, "invalid sides: #{a}, #{b}, #{c}"   if a+b <= c
  case [a,b,c].uniq.size
  when 1; :equilateral
  when 2; :isoceles
  when 3; :scalene
  end
end

describe "#classify_triangle" do
  context "with valid sides" do
    it "identifies equilateral triangles" do
      classify_triangle(3,3,3).should == :equilateral
    end

    it "identifies isoceles triangles" do
      classify_triangle(3,3,2).should == :isoceles
      classify_triangle(3,2,3).should == :isoceles
      classify_triangle(2,3,3).should == :isoceles
    end

    it "identifies scalene triangles" do
      classify_triangle(4,5,6).should == :scalene
    end
  end

  context "with invalid sides" do
    it "fails" do
      lambda { classify_triangle(0,0,0) }.should raise_error(ArgumentError, /invalid/)
      lambda { classify_triangle(1,2,3) }.should raise_error(ArgumentError, /invalid/)
    end
  end
end
