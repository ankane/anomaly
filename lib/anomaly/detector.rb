module Anomaly
  class Detector

    def initialize(data = nil)
      @m = 0
      train(data) if data
    end

    def train(data)
      if defined?(NMatrix)
        d = NMatrix.to_na(data)
        @n, @m = d.sizes
        # Convert these to an array for Marshal.dump
        @mean = d.mean(1).to_a
        @std = d.stddev(1).to_a
      else
        # Default to Array, since built-in Matrix does not give us a big performance advantage.
        d = data.to_a
        @m = d.size
        @n = d.first ? d.first.size : 0
        cols = @n.times.map{|i| d.map{|r| r[i]}}
        @mean = cols.map{|c| mean(c)}
        @std = cols.each_with_index.map{|c,i| std(c, @mean[i])}
      end
      @std.map!{|std| (std == 0 or std.nan?) ? Float::MIN : std}
    end

    def trained?
      @m > 0
    end

    def samples
      @m
    end

    # Limit the probability of features to [0,1]
    # to keep probabilities at same scale.
    def probability(x)
      raise "Train me first" unless trained?
      raise ArgumentError, "x must have #{@n} elements" if x.size != @n
      @n.times.map do |i|
        p = normal_pdf(x[i], @mean[i], @std[i])
        (p.nan? or p > 1) ? 1 : p
      end.reduce(1, :*)
    end

    def anomaly?(x, epsilon)
      probability(x) < epsilon
    end

    protected

    SQRT2PI = Math.sqrt(2*Math::PI)

    def normal_pdf(x, mean = 0, std = 1)
      1/(SQRT2PI*std)*Math.exp(-((x - mean)**2/(2.0*(std**2))))
    end

    # Not used for NArray

    def mean(x)
      x.inject(0.0){|a, i| a + i}/x.size
    end

    def std(x, mean)
      Math.sqrt(x.inject(0.0){|a, i| a + (i - mean) ** 2}/(x.size - 1))
    end

  end
end
