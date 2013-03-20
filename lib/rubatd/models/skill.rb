module Rubatd
  class Skill < Model
    attr_accessor :name, :team, :teammate, :queue

    def validate
      assert_present :name
      %i[team teammate queue].each do |name|
        assert_present name
        relation = send(name)
        expected_klass = Rubatd.const_get(name.to_s.capitalize)
        assert relation.is_a?(expected_klass), [name, :"not_a_#{name}"]
        if relation.respond_to?(:persisted?)
          assert relation.persisted?, [name, :not_persisted]
        end
      end
    end
  end
end
