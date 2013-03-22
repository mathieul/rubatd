require "spec_helper"

include Rubatd

class Movie < Model
  attr_accessor :title, :number, :info
  reserve_attributes :info
end
class Rubatd::RedisAccessors::Movie < RedisAccessors::Base
  embedded_key :info do |model, key|
    key.set(Marshal.dump(model.info)) if model.info
  end
end

class Actor < Model
  attr_accessor :name, :movie
end
class Rubatd::RedisAccessors::Actor < RedisAccessors::Base
  reference "Movie"
end

describe RedisAccessors::Base do
  let(:redis) { Redis.new(redis_config) }
  let(:movie_accessor) { RedisAccessors::Movie.new(redis) }

  context "#save: save to redis" do
    let(:model) { Movie.new("title" => "Goldfinger", "number" => "007") }

    it "#save raises an error if model is not valid" do
      model.should_receive(:valid?).and_return(false)
      expect { movie_accessor.save(model) }.to raise_error(ModelInvalid)
    end

    it "sets the model id if not set" do
      movie_accessor.save(model)
      expect(model.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      model.id = "42"
      movie_accessor.save(model)
      expect(model.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      movie_accessor.save(model)
      expect(redis.smembers("Movie:all")).to eq(["1"])
    end

    it "stores the model attributes" do
      movie_accessor.save(model)
      expect(redis.hgetall("Movie:1")).to eq(
        "title" => "Goldfinger", "number" => "007"
      )
    end

    it "sets the model as persisted" do
      model.should_receive(:persisted!)
      movie_accessor.save(model)
    end

    it "can save more than 1 model" do
      model2 = Movie.new("title" => "GoldenEye")
      movie_accessor.save(model, model2)
      expect(model.id).to eq("1")
      expect(model2.id).to eq("2")
    end
  end

  context "#get: read model from redis by id" do
    let(:goldfinger) { Movie.new("title" => "Goldfinger", "number" => "007") }
    before(:each) { movie_accessor.save(goldfinger) }

    it "finds the model by id" do
      model = movie_accessor.get(goldfinger.id)
      expect(model.id).to eq(goldfinger.id)
    end

    it "can remember the original persisted attributes" do
      model = movie_accessor.get(goldfinger.id)
      model.title = "Goldeneye"
      model.number = nil
      expect(model.attributes).to eq("title" => "Goldeneye")
      expect(model.persisted_attributes).to eq("title" => "Goldfinger", "number" => "007")
    end

    it "return a persisted model" do
      model = movie_accessor.get(goldfinger.id)
      expect(model).to be_persisted
    end

    it "raises an error if no model exists for this id" do
      expect { movie_accessor.get("does-not-exist") }.to raise_error(ModelNotFound)
    end
  end

  context "#delete: delete a model from redis" do
    let(:model) { Movie.new("title" => "Goldfinger", "number" => "007") }
    before(:each) { movie_accessor.save(model) }

    it "deletes the model id to the list of all model ids" do
      movie_accessor.delete(model)
      expect(redis.smembers("Movie:all")).to eq([])
    end

    it "deletes the model attributes" do
      movie_accessor.delete(model)
      expect(redis.hgetall("Movie:1")).to eq({})
    end

    it "sets the model as not persisted" do
      movie_accessor.delete(model)
      expect(model).to_not be_persisted
    end
  end

  context "model references" do
    let(:actor_accessor) { RedisAccessors::Actor.new(redis) }
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

    it "cleans-up old references when updated if they changed" do
      movie_accessor.save(moonraker)
      moore.movie = moonraker
      actor_accessor.save(moore)
      moore.movie = nil
      actor_accessor.save(moore)
      expect(redis.smembers("Actor:indices:movie_id:007")).to eq([])
    end

    it "cleans-up references when deleting the model" do
      movie_accessor.save(moonraker)
      moore.movie = moonraker
      actor_accessor.save(moore)
      actor_accessor.delete(moore)
      expect(redis.smembers("Actor:indices:movie_id:007")).to eq([])
    end

    it "also load a model references with #get" do
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

  context "embedded keys" do
    it "saves embedded keys when saving the model" do
      movie = Movie.new("id" => "10", "title" => "The Spy Who Loved Me")
      movie.info = {year: 1977}
      movie_accessor.save(movie)
      info = Marshal.load(redis.get("Movie:10:info"))
      expect(info).to eq(year: 1977)
    end
  end
end
