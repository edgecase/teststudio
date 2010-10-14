def with(field)
  Struct.new(field).new(1)
end

describe "as size" do
  subject { with(:size) }
  it { should have(1).turn }
end

describe "as length" do
  subject { with(:length) }
  it { should have(1).turn }
end

describe "as turns with size" do
  subject { Struct.new(:turns).new(with(:size)) }
  it { should have(1).turn }
end

describe "as turns with length" do
  subject { Struct.new(:turns).new(with(:length)) }
  it { should have(1).turn }
end

describe "as turn with size" do
  subject { Struct.new(:turn).new(with(:size)) }
  it { should have(1).turn }
end

describe "as turn with length" do
  subject { Struct.new(:turn).new(with(:length)) }
  it { should have(1).turn }
end

describe "should break" do
  subject { Struct.new(:turn).new(with(:lengthx)) }
  it { should have(1).turn; fail "OUCH" }
end

