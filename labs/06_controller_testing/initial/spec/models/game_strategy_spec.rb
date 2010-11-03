require 'spec_helper'

describe GameStrategy do
  subject { GameStrategy.new }
  its(:roll_again?) { should be_false }
end
