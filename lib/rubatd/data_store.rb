class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @accessors = {}
  end

  def save(model)
    accessor_klass(model.type_name).new(db).save(model)
  end

  def find(args)
    type_name, id = args.first
    accessor(model).find(id)
  end

  private

  def accessor_klass(model_type)
    @accessors[model_type] ||= begin
      name = "#{type.to_s.camelize}#{model_type}"
      Rubatd::Accessors.const_get(name)
    end
  end
end
