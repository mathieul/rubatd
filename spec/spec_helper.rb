require "pry"

Dir.glob("#{__dir__}/support/**/*.rb") { |file_name| require(file_name) }

require File.join(__dir__, "..", "lib", "rubatd")

RSpec.configure do |config|
  config.before(:all)  { Ohm.connect(url: "redis://127.0.0.1:6379/7") }
  config.before(:each) { Ohm.flush }
end