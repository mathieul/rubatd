require "scrivener"

module Rubatd
  class Model
      include Scrivener::Validations
      attr_accessor :id

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
      @id ||= generate_id
      after_initialize(attributes)
    end

    def validate
      assert_present :id
      after_validate
    end

    def after_initialize(attributes)
    end

    private

    def generate_id
      rand(2**64).to_s(16)
    end
  end
end
