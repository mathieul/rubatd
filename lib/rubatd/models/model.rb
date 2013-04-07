require "virtus"
require "scrivener"

module Rubatd
  class Model
    include Virtus
    include Scrivener::Validations

    attr_accessor :uid, :persisted_attributes

    def assert_valid!
      unless valid?
        messages = errors.map do |attribute, list|
          "#{attribute} is #{list.join(", ")}"
        end
        raise ModelInvalid, messages.join(" -")
      end
    end
  end
end
