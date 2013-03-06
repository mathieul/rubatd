require "ohm"
Dir.glob("#{__dir__}/rubatd/models/**/*.rb") { |file_name| require(file_name) }
