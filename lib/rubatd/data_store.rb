class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @accessors = {}
  end

  def save(model)
    model_store(model).save
  end

  private

  def model_store(model)
    @accessors[type] ||= begin
      name = "#{type.to_s.camelize}#{model.type_name}"
      klass = Rubatd::Accessors.const_get(name)
      klass.new(model, db)
    end
  end
end
