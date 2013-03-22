Rubatd = Module.new
Rubatd::Error = Class.new(StandardError)

require "rubatd/core_extensions"
require "rubatd/models"
require "rubatd/redis_accessors"
require "rubatd/data_store"
require "rubatd/team_orchestrator"
