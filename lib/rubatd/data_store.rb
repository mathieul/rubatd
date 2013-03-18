class Rubatd::DataStore
  attr_reader :db, :type

  def initialize(type, db_adapter_class, config)
    @type = type
    @db = db_adapter_class.new(config)
    @accessors = {}
  end

  def save(model)
    accessor(model.type_name).save(model)
  end

  def delete(model)
    accessor(model.type_name).delete(model)
  end

  def get(subject, id: nil, referrers: nil)
    case subject
    when String, Symbol
      model_type = subject.to_s.camelize
      accessor(model_type).get(id)
    else
      model_type = referrers.to_s.camelize
      fetch_referrers(subject, model_type)
    end
  end

  private

  def accessor(model_type)
    @accessors[model_type] ||= begin
      container = Rubatd.const_get(:"#{type.to_s.camelize}Accessors")
      container.for(db, model_type)
    end
  end

  def fetch_referrers(referee, model_type)
    accessor(referee.type_name).referrers(model_type, referee.id)
  end
end
