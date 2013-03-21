require "scrivener"

module Rubatd
  class Model
    include Scrivener::Validations

    attr_accessor :id
    attr_reader   :persisted_attributes

    class << self
      def reserved_attributes
        @reserved_attributes ||= default_reserved_attributes
      end

      def reserve_attributes(*attributes)
        names = attributes.map { |attribute| :"@#{attribute}" }
        reserved_attributes.push(*names)
      end

      private

      def default_reserved_attributes
        reservable = ancestors[1..-1].find { |klass| klass.respond_to?(:reserved_attributes) }
        reservable ? reservable.reserved_attributes.dup : []
      end
    end

    reserve_attributes :id, :errors, :persisted_attributes

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
      post_initialize(attributes)
    end

    def post_initialize(attributes)
      # can be overriden by children
    end

    def attributes
      except = self.class.reserved_attributes
      names = instance_variables.reject { |name| except.include?(name) }
      names.each_with_object({}) do |name, attributes|
        value = instance_variable_get(name)
        attributes[name[1..-1]] = value unless value.nil?
      end
    end

    def type_name
      self.class.to_s.split(/::/).last
    end

    def persisted?
      !@persisted_attributes.nil?
    end

    def persisted!(persisted_attributes)
      @persisted_attributes = persisted_attributes
    end

    def not_persisted!
      @persisted_attributes = nil
    end
  end
end
