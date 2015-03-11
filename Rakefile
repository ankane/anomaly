#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec")

require "benchmark"
require "anomaly"

task :benchmark do
  examples = 1_000_000.times.map { [rand, rand, rand, 0] }

  Benchmark.bm do |x|
    x.report { Anomaly::Detector.new(examples, :eps => 0.5) }
    require "narray"
    x.report { Anomaly::Detector.new(examples, :eps => 0.5) }
  end
end

task :random_examples do
  examples = 10_000.times.map { [rand, rand(10), rand(100), 0] } +
             100.times.map { [rand + 1, rand(10) + 2, rand(100) + 20, 1] }

  ad = Anomaly::Detector.new(examples)
  puts ad.eps
end
