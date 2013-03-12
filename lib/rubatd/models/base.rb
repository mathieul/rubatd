require "scrivener"

module Rubatd
  class Model
    include Scrivener::Validations

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
    end

    def id
      @_id
    end

    def id=(id)
      @_id = id
    end

    def attributes
      names = instance_variables.reject { |name| name == :@errors || name[1] == "_" }
      names.each_with_object({}) do |name, attributes|
        attributes[name[1..-1]] = instance_variable_get(name)
      end
    end

    def type_name
      self.class.to_s.split(/::/).last
    end

    def persisted?
      !!@_persisted
    end

    def persisted!
      @_persisted = true
    end
  end
end
