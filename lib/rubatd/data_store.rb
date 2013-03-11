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
      name = "#{type.to_s.camelize}#{model.type_name}"
      klass = Rubatd::Stores.const_get(name)
      klass.new(model, db)
    end
  end
end
