require 'spec_helper'

describe RandomSource do
  let(:source) { RandomSource.new }
  let(:random_numbers) { source.random_numbers(sample_size) }

  context "with a small sample size" do
    let(:sample_size) { 100 }

    subject { random_numbers }

    it { should have(sample_size).numbers }
    it { should all_be { |n| n >= 1 } }
    it { should all_be { |n| n <= 6 } }
  end

  context "with a large sample size" do
    let(:sample_size) { 100000 }
    let(:expected_bin_size) { sample_size / 6.0 }

    subject { count_occurrences(random_numbers) }

    it { should have(6).bins }

    it "is randomly distributed" do
      subject.each do |n, count|
        count.should be_within_percent(expected_bin_size, 5)
      end
    end

    private

    def count_occurrences(numbers)
      result = Hash.new { |h, k| h[k] = 0 }
      numbers.each do |n| result[n] += 1 end
      result
    end
  end
end
