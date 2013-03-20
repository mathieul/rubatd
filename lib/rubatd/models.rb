module Rubatd
  ModelInvalid  = Class.new(Rubatd::Error)
  ModelNotFound = Class.new(Rubatd::Error)
  ModelNotSaved = Class.new(Rubatd::Error)
end

require "rubatd/models/model"
require "rubatd/models/team"
require "rubatd/models/teammate"
require "rubatd/models/queue"
require "rubatd/models/task"
require "rubatd/models/skill"
