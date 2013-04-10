Rubatd = Module.new
Rubatd::Error = Class.new(StandardError)

require "rubatd/core_extensions"
require "rubatd/models"
require "rubatd/data_store"
require "rubatd/task_distributor"
require "rubatd/team_orchestrator"
