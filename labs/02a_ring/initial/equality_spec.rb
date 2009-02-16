
describe "equality checks" do
  
  it "should determine structrual equality" do
    a = [1,2]
    b = [1,2]

    a.should == b
    a.should_not be_equal(b)
    a.should_not be(b)
  end


  it "should determine identity equality" do
    a = [1,2]
    b = a

    a.should == b
    a.should be(b)
    a.should be_equal(b)
  end

  it "should be type equal" do
    a = 1
    b = 1.0

    a.should  == b
    a.should_not be_eql(b)
    a.should_not be_equal(b)
    a.should_not be(b)
  end

end


