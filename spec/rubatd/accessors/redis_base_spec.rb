require "spec_helper"

include Rubatd

class Movie
  attr_accessor :id, :errors, :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end
  def type_name
    "Movie"
  end
  def valid?
    true
  end
  def persisted!
  end
end

Rubatd::Accessors::RedisMovie = Class.new(Accessors::RedisBase)

class Actor
  attr_accessor :id, :attributes, :movie
  def initialize(attributes = {})
    @attributes = attributes
  end
  def type_name
    "Actor"
  end
  def valid?
    true
  end
  def persisted!
  end
end

class Rubatd::Accessors::RedisActor < Accessors::RedisBase
  reference "Movie"
end

describe Accessors::RedisBase do
  let(:accessor) { Accessors::RedisMovie.new(Redis.new(redis_config)) }

  context "#save: save to redis" do
    let(:model) { Movie.new("title" => "Goldfinger", "number" => "007") }

    it "#save raises an error if teammate is not valid" do
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
      expect(model.attributes).to eq("id" => "1", "title" => "Goldfinger", "number" => "007")
    end

    it "raises an error if no model exists for this id" do
      expect { accessor.get("does-not-exist") }.to raise_error(ModelNotFound)
    end
  end

  context "model references" do
    it "#save a model with a reference indexes the reference id" do
      moonraker = Movie.new.tap { |m| m.id = "007" }
      moore = Actor.new("name" => "Roger Moore").tap { |m| m.id = "3" }
      moore.movie = moonraker
      accessor = Accessors::RedisActor.new(Redis.new(redis_config))
      accessor.save(moore)
      expect(redis.smembers("Actor:indices:movie_id:007")).to eq(["3"])
    end

    it "#referrers reads the referrers to a model" do
      redis.sadd("Actor:indices:movie_id:007", "12")
      redis.sadd("Actor:indices:movie_id:007", "42")
      redis.hmset("Actor:12", "name", "Sean Connery")
      redis.hmset("Actor:42", "name", "Daniel Craig")
      referrers = accessor.referrers("Actor", "007")
      expect(referrers.length).to eq(2)
      connery, craig = referrers.sort { |a, b| a.id <=> b.id }
      expect(connery.attributes["name"]).to eq("Sean Connery")
      expect(craig.attributes["name"]).to eq("Daniel Craig")
    end
  end
end
