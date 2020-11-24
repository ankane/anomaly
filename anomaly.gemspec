require_relative "lib/anomaly/version"

Gem::Specification.new do |spec|
  spec.name          = "anomaly"
  spec.version       = Anomaly::VERSION
  spec.summary       = "Easy-to-use anomaly detection for Ruby"
  spec.homepage      = "https://github.com/ankane/anomaly"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2"
  spec.add_development_dependency "narray"
  spec.add_development_dependency "numo-narray"
end
