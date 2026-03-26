require "bundler/setup"
Bundler.require

require "numo/narray/alt" if ENV["ENGINE"] == "numo"

RSpec.configure do
end
