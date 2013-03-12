class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @accessors = {}
  end

  def save(model)
    accessor = accessor_klass(model).new(model, db)
    accessor.save
  end

  private

  def accessor_klass(model)
    @accessors[model.type_name] ||= begin
      name = "#{type.to_s.camelize}#{model.type_name}"
      Rubatd::Accessors.const_get(name)
    end
  end
end
