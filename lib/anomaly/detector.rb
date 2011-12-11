module Anomaly
  class Detector

    def initialize(data)
      # Use NMatrix if possible
      if defined?(NMatrix) and (!defined?(Matrix) or !data.is_a?(Matrix))
        d = data.is_a?(NMatrix) ? data : NMatrix.to_na(data)

        # Convert these to an array for Marshal.dump
        @mean = d.mean(1).to_a
        @std = d.stddev(1).to_a
      else
        d = data.is_a?(Matrix) ? data : Matrix.rows(data)
        cols = d.column_size.times.map{|i| d.column(i)}
        @mean = cols.map{|c| mean(c)}
        @std = cols.each_with_index.map{|c,i| std(c, @mean[i])}
      end

      raise "Standard deviation cannot be zero" if @std.find_index{|i| i == 0 or i.nan?}
    end

    def probability(x)
      raise ArgumentError, "x must have #{@mean.size} elements" if x.size != @mean.size
      x.each_with_index.map{|a,i| normal_pdf(a, @mean[i], @std[i]) }.reduce(1, :*)
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
