module Anomaly
  class Detector
    attr_reader :mean, :std
    attr_accessor :eps

    def initialize(examples = nil, opts = {})
      @m = 0
      train(examples, opts) if examples
    end

    def train(examples, opts = {})
      raise "No examples" if examples.empty?
      raise "Must have at least two columns" if examples.first.size < 2

      # Divide into groups since we only want to train with non-anomalies.
      anomalies = []
      non_anomalies = []
      examples.each do |example|
        if example.last == 0
          non_anomalies << example
        else
          anomalies << example
        end
      end

      raise "Must have at least one non-anomaly" if non_anomalies.empty?

      @eps = (opts[:eps] || 0).to_f
      if @eps > 0
        # Use all non-anomalies to train.
        training_examples = non_anomalies
      else
        training_examples, test_examples = partition!(non_anomalies)
        test_examples.concat(anomalies)
      end
      # Remove last column.
      training_examples = training_examples.map { |e| e[0..-2] }
      @m = training_examples.size
      @n = training_examples.first.size

      if defined?(NMatrix)
        training_examples = NMatrix.to_na(training_examples)
        # Convert these to an Array for Marshal.dump
        @mean = training_examples.mean(1).to_a
        @std = training_examples.stddev(1).to_a
      else
        # Default to Array, since built-in Matrix does not give us a big performance advantage.
        cols = @n.times.map { |i| training_examples.map { |r| r[i] } }
        @mean = cols.map { |c| alt_mean(c) }
        @std = cols.each_with_index.map { |c, i| alt_std(c, @mean[i]) }
      end
      @std.map! { |std| (std == 0 || std.nan?) ? Float::MIN : std }

      if @eps == 0
        # Find the best eps.
        epss = (1..9).map { |i| [1, 3, 5, 7, 9].map { |j| (j * 10**(-i)).to_f } }.flatten
        f1_scores = epss.map { |eps| [eps, compute_f1_score(test_examples, eps)] }
        @eps, best_f1 = f1_scores.max_by { |v| v[1] }
      end
    end

    def trained?
      @m > 0
    end

    # Limit the probability of features to [0,1]
    # to keep probabilities at same scale.
    def probability(x)
      raise "Train me first" unless trained?
      raise ArgumentError, "First argument must have #{@n} elements" if x.size != @n
      @n.times.map do |i|
        p = normal_pdf(x[i], @mean[i], @std[i])
        (p.nan? || p > 1) ? 1 : p
      end.reduce(1, :*)
    end

    def anomaly?(x, eps = @eps)
      probability(x) < eps
    end

    protected

    SQRT2PI = Math.sqrt(2 * Math::PI)

    def normal_pdf(x, mean = 0, std = 1)
      1 / (SQRT2PI * std) * Math.exp(-((x - mean)**2 / (2.0 * (std**2))))
    end

    # Find best eps.

    def partition!(examples, p_last = 0.2)
      examples.shuffle!
      n = (examples.size * p_last).floor
      [examples[n..-1], examples[0...n]]
    end

    def compute_f1_score(examples, eps)
      tp = 0
      fp = 0
      fn = 0
      examples.each do |example|
        act = example.last != 0
        pred = self.anomaly?(example[0..-2], eps)
        if act && pred
          tp += 1
        elsif pred # and !act
          fp += 1
        elsif act # and !pred
          fn += 1
        end
      end
      f1_score(tp, fp, fn)
    end

    def f1_score(tp, fp, fn)
      precision = tp / (tp + fp).to_f
      recall = tp / (tp + fn).to_f
      score = 2.0 * precision * recall / (precision + recall)
      score.nan? ? 0.0 : score
    end

    # Not used for NArray

    def alt_mean(x)
      x.inject(0.0) { |a, i| a + i } / x.size
    end

    def alt_std(x, mean)
      Math.sqrt(x.inject(0.0) { |a, i| a + (i - mean)**2 } / (x.size - 1))
    end
  end
end
