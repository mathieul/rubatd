require "scrivener"

module Model
  def self.included(base)
    base.instance_eval do
      include Scrivener::Validations
      attr_accessor :id
    end
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) if respond_to?(name) }
    @id ||= generate_id
  end

  private

  def generate_id
    rand(2**64).to_s(16)
  end
end
