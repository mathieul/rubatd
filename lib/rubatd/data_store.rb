class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @accessors = {}
  end

  def save(model)
    self[model.type_name].save(model)
  end

  def [](model_type)
    @accessors[model_type] ||= begin
      name = "#{type.to_s.camelize}#{model_type}"
      Rubatd::Accessors.const_get(name).new(db)
    end
  end
end
