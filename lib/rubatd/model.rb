require "scrivener"

module Rubatd
  class Model
      include Scrivener::Validations
      attr_accessor :id

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
      after_initialize(attributes)
    end

    def validate
      assert_present :id
      after_validate
    end

    def attributes
      names = instance_variables.reject { |name| name == :@id }
      names.each_with_object({}) do |name, attributes|
        attributes[name] = instance_variable_get(name)
      end
    end

    def after_initialize(attributes)
    end

    def after_validate
    end
  end
end
