require "spec_helper"

include Rubatd

class Movie < Model
  attr_accessor :title, :number
end
Rubatd::RedisAccessors::Movie = Class.new(RedisAccessors::Base)

class Actor < Model
  attr_accessor :name, :movie
end
class Rubatd::RedisAccessors::Actor < RedisAccessors::Base
  reference "Movie"
end

describe RedisAccessors::Base do
  let(:accessor) { RedisAccessors::Movie.new(Redis.new(redis_config)) }

  context "#save: save to redis" do
    let(:model) { Movie.new("title" => "Goldfinger", "number" => "007") }

    it "#save raises an error if model is not valid" do
      model.should_receive(:valid?).and_return(false)
      expect { accessor.save(model) }.to raise_error(ModelInvalid)
    end

    it "sets the model id if not persisted" do
      accessor.save(model)
      expect(model.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      model.id = "42"
      accessor.save(model)
      expect(model.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      2.times do
        accessor.save(model)
        expect(redis.smembers("Movie:all")).to eq(["1"])
      end
    end

    it "stores the model attributes" do
      accessor.save(model)
      expect(redis.hgetall("Movie:1")).to eq(
        "title" => "Goldfinger", "number" => "007"
      )
    end

    it "sets the model as persisted" do
      model.should_receive(:persisted!)
      accessor.save(model)
    end
  end

  context "#get: read model from redis by id" do
    it "finds the model id" do
      accessor.save(Movie.new("title" => "Goldfinger", "number" => "007"))
      model = accessor.get("1")
      expect(model.attributes).to eq("title" => "Goldfinger", "number" => "007")
    end

    it "raises an error if no model exists for this id" do
      expect { accessor.get("does-not-exist") }.to raise_error(ModelNotFound)
    end
  end

  context "model references" do
    let(:movie_accessor) { accessor }
    let(:actor_accessor) { RedisAccessors::Actor.new(Redis.new(redis_config)) }
    let(:moonraker) { Movie.new("title" => "Moonraker").tap { |m| m.id = "007" } }
    let(:moore) do
      Actor.new("name" => "Roger Moore").tap { |moore| moore.id = "3" }
    end

    it "indexes its references when saved" do
      movie_accessor.save(moonraker)
      moore.movie = moonraker
      actor_accessor.save(moore)
      expect(redis.smembers("Actor:indices:movie_id:007")).to eq(["3"])
    end

    it "also load a model references with #get", wip: true do
      movie_accessor.save(moonraker)
      moore.movie = moonraker
      actor_accessor.save(moore)
      actor = actor_accessor.get(moore.id)
      expect(actor.movie.id).to eq(moonraker.id)
    end

    it "fetches a model referrers with #referrers" do
      redis.sadd("Actor:indices:movie_id:007", "42")
      redis.hmset("Actor:42", "name", "Daniel Craig")
      referrers = movie_accessor.referrers("Actor", "007")
      expect(referrers.map(&:attributes)).to eq([{"name" => "Daniel Craig"}])
    end

    it "raises an error if a referee is not persisted when saving" do
      moore.movie = moonraker
      expect { actor_accessor.save(moore) }.to raise_error(ModelNotSaved)
    end
  end
end
