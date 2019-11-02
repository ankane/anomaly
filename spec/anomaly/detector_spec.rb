require "spec_helper"

describe Anomaly::Detector do
  let(:examples) { [[-1, -2, 0], [0, 0, 0], [1, 2, 0]] }
  let(:ad) { Anomaly::Detector.new(examples) }

  it "computes anomaly" do
    expect(ad.anomaly?([0, 0])).to eq(true)
  end

  it "computes multiple anomalies" do
    expect(ad.anomaly?([[0, 0], [0, 0]])).to eq([true, true])
  end

  # mean = [0, 0], std = [1, 2]
  it "computes the right probability" do
    expect(ad.probability([0, 0])).to eq(0.079577471545947667)
  end

  it "computes multiple probabilities" do
    expect(ad.probability([[0, 0], [0, 0]])).to eq([0.079577471545947667, 0.079577471545947667])
  end

  it "computes the right mean" do
    expect(ad.mean).to eq([0, 0])
  end

  it "computes the right standard deviation" do
    expect(ad.std).to eq([1, 2])
  end

  it "marshalizes" do
    expect { Marshal.dump(ad) }.to_not raise_error
  end

  context "when standard deviation is 0" do
    let(:examples) { [[0, 0], [0, 0]] }

    it "returns infinity for mean" do
      expect(ad.probability([0])).to eq(1)
    end

    it "returns 0 for not mean" do
      expect(ad.probability([1])).to eq(0)
    end
  end

  context "when lots of samples" do
    let(:examples) { m.times.map { [0, 0] } }
    let(:m) { rand(100) + 1 }

    it { expect(ad.trained?).to be_truthy }
  end

  context "when no samples" do
    let(:examples) { nil }

    it { expect(ad.trained?).to be_falsey }
  end

  context "when pdf is greater than 1" do
    let(:examples) { 100.times.map { [0, 0] }.push([1, 0]) }

    it { expect(ad.probability([0])).to eq(1) }
  end

  context "when only anomalies" do
    let(:examples) { [[0, 1]] }

    it "raises error" do
      expect { ad }.to raise_error RuntimeError, "Must have at least one non-anomaly"
    end
  end

  context "when only one non-anomaly" do
    let(:examples) { [[0, 0]] }

    it { expect(ad.eps).to eq(1e-1) }
  end
end
