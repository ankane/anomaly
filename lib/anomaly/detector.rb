module Anomaly
  class Detector

    def initialize(data = nil)
      @trained = false
      train(data) if data
    end

    def train(data)
      if defined?(NMatrix)
        d = NMatrix.to_na(data)
        # Convert these to an array for Marshal.dump
        @mean = d.mean(1).to_a
        @std = d.stddev(1).to_a
      else
        # Default to Array, since built-in Matrix does not give us a big performance advantage.
        d = data.to_a
        cols = d.first.size.times.map{|i| d.map{|r| r[i]}}
        @mean = cols.map{|c| mean(c)}
        @std = cols.each_with_index.map{|c,i| std(c, @mean[i])}
      end

      @std.map!{|std| (std == 0 or std.nan?) ? Float::MIN : std}

      # raise "Standard deviation cannot be zero" if @std.find_index{|i| i == 0 or i.nan?}

      @trained = true
    end

    def trained?
      @trained
    end

    def probability(x)
      raise "Train me first" unless trained?
      raise ArgumentError, "x must have #{@mean.size} elements" if x.size != @mean.size
      x.each_with_index.map{|a,i| normal_pdf(a, @mean[i], @std[i]) }.reduce(1, :*)
    end

    def anomaly?(x, epsilon)
      probability(x) < epsilon
    end

    protected

    SQRT2PI = Math.sqrt(2*Math::PI)

    # Return 1 (exclude feature) if std ~ 0
    def normal_pdf(x, mean = 0, std = 1)
      p = 1.0/(SQRT2PI*std)*Math.exp(-((x - mean)**2/(2.0*(std**2))))
      p.nan? ? 1 : p
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
