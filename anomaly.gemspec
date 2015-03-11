# -*- encoding: utf-8 -*-
require File.expand_path("../lib/anomaly/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Kane"]
  gem.email         = ["andrew@chartkick.com"]
  gem.description   = "Easy-to-use anomaly detection"
  gem.summary       = "Easy-to-use anomaly detection"
  gem.homepage      = "https://github.com/ankane/anomaly"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "anomaly"
  gem.require_paths = ["lib"]
  gem.version       = Anomaly::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 2.0.0"
  gem.add_development_dependency "narray"
end
