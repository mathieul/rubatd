module Rubatd::Accessors
  def self.for(db_type, db, model_type)
    name = "#{db_type.to_s.camelize}#{model_type}"
    Rubatd::Accessors.const_get(name).new(db)
  end
end

require "rubatd/accessors/redis_base"
require "rubatd/accessors/redis_team"
require "rubatd/accessors/redis_teammate"
