require "pry"
require "redis"
require "factory_girl"

require File.join(__dir__, "..", "lib", "rubatd")

module GlobalConfigHelpers
  def redis_config
    {url: "redis://127.0.0.1:6379/7"}
  end

  def redis
    @redis ||= Redis.new(redis_config)
  end
end

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include GlobalConfigHelpers
  config.after(:each) { redis.flushdb }
end
