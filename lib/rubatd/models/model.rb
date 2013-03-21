require "scrivener"

module Rubatd
  class Model
    include Scrivener::Validations

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
      post_initialize(attributes)
    end

    def post_initialize(attributes)
      # can be overriden by children
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
        value = instance_variable_get(name)
        attributes[name[1..-1]] = value unless value.nil?
      end
    end

    def type_name
      self.class.to_s.split(/::/).last
    end

    def persisted?
      !@_persisted_attributes.nil?
    end

    def persisted!(persisted_attributes)
      @_persisted_attributes = persisted_attributes
    end

    def not_persisted!
      @_persisted_attributes = nil
    end

    def persisted_attributes
      @_persisted_attributes
    end
  end
end
