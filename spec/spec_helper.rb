require "bundler/setup"

require "anomaly"
require "narray" if ENV["ENGINE"] == "narray"
require "numo/narray" if ENV["ENGINE"] == "numo-narray"

RSpec.configure do
end
