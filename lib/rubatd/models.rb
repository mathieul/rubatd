module Rubatd
  ModelInvalid  = Class.new(Rubatd::Error)
end

require "rubatd/models/model"
require "rubatd/models/team"
require "rubatd/models/teammate"
require "rubatd/models/task_queue"
require "rubatd/models/task"
require "rubatd/models/skill"
