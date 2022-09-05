require "bundler/setup"
Bundler.require

require "numo/narray" if ENV["ENGINE"] == "numo-narray"

RSpec.configure do
end
