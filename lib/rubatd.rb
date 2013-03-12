Rubatd = Module.new
Rubatd::Error = Class.new(StandardError)

require "rubatd/core_extensions"
require "rubatd/models"
require "rubatd/accessors"
require "rubatd/data_store"
