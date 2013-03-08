require "pry"
require "redis"

Dir.glob("#{__dir__}/support/**/*.rb") { |file_name| require(file_name) }

require File.join(__dir__, "..", "lib", "rubatd")

module GlobalConfigHelpers
  def data_store_config
    {
      redis: redis_config
    }
  end

  def redis_config
    {
      url: "redis://127.0.0.1:6379/7"
    }
  end

  def redis
    @redis ||= Redis.new(redis_config)
  end
end

RSpec.configure do |config|
  config.include GlobalConfigHelpers
  config.after(:all) { redis.flushdb }
end
