require "spec_helper"

describe Anomaly::Detector do
  let(:data) { [[-1,-2],[0,0],[1,2]] }
  let(:ad) { Anomaly::Detector.new(data) }

  # mean = [0, 0], std = [1, 2]
  it "computes the right probability" do
    ad.probability([0,0]).should == 0.079577471545947667
  end

  it "marshalizes" do
    expect{ Marshal.dump(ad) }.to_not raise_error
  end

  context "when standard deviation is 0" do
    let(:data) { [[0],[0]] }

    it "returns infinity for mean" do
      ad.probability([0]).should == 1
    end

    it "returns 0 for not mean" do
      ad.probability([1]).should == 0
    end
  end

  context "when data is an array" do
    let(:data) { [[-1,-2],[0,0],[1,2]] }
    let(:sample) { [rand, rand] }

    it "returns the same probability as an NMatrix" do
      prob = ad.probability(sample)
      Object.send(:remove_const, :NMatrix)
      prob.should == Anomaly::Detector.new(data).probability(sample)
    end
  end

  context "when lots of samples" do
    let(:data) { m.times.map{[0]} }
    let(:m) { rand(100) + 1 }

    it { ad.samples.should == m }
    it { ad.trained?.should be_true }
  end

  context "when no samples" do
    let(:data) { [] }

    it { ad.samples.should == 0 }
    it { ad.trained?.should be_false }
  end

  context "when pdf is greater than 1" do
    let(:data) { 100.times.map{[0]}.push([1]) }

    it { ad.probability([0]).should == 1 }
  end
end
