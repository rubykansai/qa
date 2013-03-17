require "test_helper"

class AnswerCounterTest < ActiveSupport::TestCase
  class Validation < self
    setup
    def setup_data
      @basic = AnswerCounter.new(:subject_id => FactoryGirl.create(:quentin_1).id)
    end

    def test_basic_is_valid
      assert_true(@basic.valid?)
    end

    def test_subject_id_is_nil
      @basic.subject_id = nil
      assert_false(@basic.valid?)
    end

    class Relation < self
      setup
      def setup_data
        @answer_counter = FactoryGirl.create(:counter_quentin_1_1)
        @subject = Subject.first
      end

      def belongs_to_subject
        assert_equal(@subject, @answer_counter.subject)
      end
    end
  end
end
