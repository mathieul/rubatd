require "inflecto"

module Rubatd
  class Skill < Model
    attribute :name,       String
    attribute :level,      Fixnum
    attribute :team,       Team
    attribute :task_queue, TaskQueue
    attribute :teammate,   Teammate

    def validate
      assert_present :name
      %i[team teammate task_queue].each do |name|
        assert_present name
        relation = send(name)
        expected_klass = Rubatd.const_get(Inflecto.camelize(name))
        assert relation.is_a?(expected_klass), [name, :"not_a_#{name}"]
      end
    end
  end
end
