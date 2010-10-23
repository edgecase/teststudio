#!/usr/bin/env ruby

def classify_triangle(a, b, c)
  if a == b && a == c
    :equilateral
  elsif a == b || b == c || a == c
    :isoceles
  else
    :scalene
  end
end

describe "#classify_triangle" do
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

