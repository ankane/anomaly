#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec")

require "benchmark"
require "anomaly"

task :benchmark do
  data = 1_000_000.times.map{ [rand, rand, rand, rand] }

  Benchmark.bm do |x|
    x.report { Anomaly::Detector.new(data) }
    require "narray"
    x.report { Anomaly::Detector.new(data) }
  end
end
