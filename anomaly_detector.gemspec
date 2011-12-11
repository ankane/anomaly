# -*- encoding: utf-8 -*-
require File.expand_path('../lib/anomaly_detector/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Kane"]
  gem.email         = ["andrew@getformidable.com"]
  gem.description   = %q{Anomaly detection using a normal distribution.}
  gem.summary       = %q{Anomaly detection using a normal distribution.}
  gem.homepage      = "https://github.com/ankane/anomaly_detector"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "anomaly_detector"
  gem.require_paths = ["lib"]
  gem.version       = AnomalyDetector::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 2.0.0"
end
