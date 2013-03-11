class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @model_stores = {}
  end

  def create(model)
    store = model_store(model)
    store.generate_model_id
    store.save
  end

  private

  def model_store(model)
    @model_stores[type] ||= begin
      name = model_store_name(model)
      klass = Rubatd::Stores.const_get(name)
      klass.new(model, db)
    end
  end

  def model_store_name(model)
    model_name = model.class.to_s.split(/::/).last
    "#{type.to_s.camelize}#{model_name}"
  end
end
