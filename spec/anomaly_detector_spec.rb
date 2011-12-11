require "spec_helper"

describe AnomalyDetector do
  let(:data) { [[-1,-2],[0,0],[1,2]] }
  let(:ad) { AnomalyDetector.new(data) }

  # mean = [0, 0], std = [1, 2]
  it "computes the right probability" do
    ad.probability([0,0]).should == 0.079577471545947667
  end

  it "marshalizes" do
    expect{ Marshal.dump(ad) }.to_not raise_error
  end

  context "when standard deviation is 0" do
    let(:data) { [[1],[1]] }

    it "raises error" do
      expect{ ad }.to raise_error RuntimeError, "Standard deviation cannot be zero"
    end
  end

  context "when one training example" do
    let(:data) { [[1]] }

    it "raises error" do
      expect{ ad }.to raise_error RuntimeError, "Standard deviation cannot be zero"
    end
  end

  context "when data is a matrix" do
    let(:data) { [[-1,-2],[0,0],[1,2]] }
    let(:sample) { [rand, rand] }

    it "returns the same probability as an NMatrix" do
      ad.probability(sample).should == AnomalyDetector.new(Matrix.rows(data)).probability(sample)
    end
  end
end
