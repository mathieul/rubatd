module Rubatd
  class Skill < Model
    attribute :level,      Fixnum
    attribute :task_queue, TaskQueue
    attribute :teammate,   Teammate

    def validate
      assert_present :name
      %i[team teammate queue].each do |name|
        assert_present name
        relation = send(name)
        expected_klass = Rubatd.const_get(name.to_s.capitalize)
        assert relation.is_a?(expected_klass), [name, :"not_a_#{name}"]
      end
    end
  end
end
