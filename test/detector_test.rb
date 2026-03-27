require_relative "test_helper"

class DetectorTest < Minitest::Test
  def test_anomaly
    assert_equal true, ad.anomaly?([0, 0])
  end

  def test_multiple_anomalies
    assert_equal [true, true], ad.anomaly?([[0, 0], [0, 0]])
  end

  # mean = [0, 0], std = [1, 2]
  def test_probability
    assert_equal 0.079577471545947667, ad.probability([0, 0])
  end

  def test_multiple_probabilities
    assert_equal [0.079577471545947667, 0.079577471545947667], ad.probability([[0, 0], [0, 0]])
  end

  def test_mean
    assert_equal [0, 0], ad.mean
  end

  def test_std
    assert_equal [1, 2], ad.std
  end

  def test_marshalizes
    assert_kind_of String, Marshal.dump(ad)
  end

  def test_serializes
    assert_equal 0.079577471545947667, Anomaly::Detector.load_json(ad.to_json).probability([0, 0])
  end

  def test_std_zero
    ad = Anomaly::Detector.new([[0, 0], [0, 0]])
    assert_equal 1, ad.probability([0])
    assert_equal 0, ad.probability([1])
  end

  def test_lots_of_samples
    ad = Anomaly::Detector.new((rand(100) + 1).times.map { [0, 0] })
    assert_equal true, ad.trained?
  end

  def test_no_samples
    ad = Anomaly::Detector.new
    assert_equal false, ad.trained?
  end

  def test_pdf_greater_than_one
    ad = Anomaly::Detector.new(100.times.map { [0, 0] } + [[1, 0]])
    assert_equal 1, ad.probability([0])
  end

  def test_only_anomalies
    error = assert_raises(ArgumentError) do
      Anomaly::Detector.new([[0, 1]])
    end
    assert_equal "Must have at least one non-anomaly", error.message
  end

  def test_only_one_non_anomaly
    ad = Anomaly::Detector.new([[0, 0]])
    assert_equal 0.1, ad.eps
  end

  private

  def ad
    Anomaly::Detector.new([[-1, -2, 0], [0, 0, 0], [1, 2, 0]])
  end
end
