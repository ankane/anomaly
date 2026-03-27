require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"

require "numo/narray/alt" if ENV["ENGINE"] == "numo"
