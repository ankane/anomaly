require "spec_helper"

describe Anomaly::Detector do
  let(:examples) { [[-1, -2, 0], [0, 0, 0], [1, 2, 0]] }
  let(:ad) { Anomaly::Detector.new(examples) }

  # mean = [0, 0], std = [1, 2]
  it "computes the right probability" do
    ad.probability([0, 0]).should == 0.079577471545947667
  end

  it "computes the right mean" do
    ad.mean.should == [0, 0]
  end

  it "computes the right standard deviation" do
    ad.std.should == [1, 2]
  end

  it "marshalizes" do
    expect { Marshal.dump(ad) }.to_not raise_error
  end

  context "when standard deviation is 0" do
    let(:examples) { [[0, 0], [0, 0]] }

    it "returns infinity for mean" do
      ad.probability([0]).should == 1
    end

    it "returns 0 for not mean" do
      ad.probability([1]).should == 0
    end
  end

  context "when examples is an array" do
    let(:examples) { [[-1, -2, 0], [0, 0, 0], [1, 2, 0]] }
    let(:sample) { [rand, rand] }

    it "returns the same probability as an NMatrix" do
      prob = ad.probability(sample)
      Object.send(:remove_const, :NMatrix)
      prob.should == Anomaly::Detector.new(examples).probability(sample)
    end
  end

  context "when lots of samples" do
    let(:examples) { m.times.map { [0, 0] } }
    let(:m) { rand(100) + 1 }

    it { ad.trained?.should be_truthy }
  end

  context "when no samples" do
    let(:examples) { nil }

    it { ad.trained?.should be_falsey }
  end

  context "when pdf is greater than 1" do
    let(:examples) { 100.times.map { [0, 0] }.push([1, 0]) }

    it { ad.probability([0]).should == 1 }
  end

  context "when only anomalies" do
    let(:examples) { [[0, 1]] }

    it "raises error" do
      expect { ad }.to raise_error RuntimeError, "Must have at least one non-anomaly"
    end
  end

  context "when only one non-anomaly" do
    let(:examples) { [[0, 0]] }

    it { ad.eps.should == 1e-1 }
  end
end
