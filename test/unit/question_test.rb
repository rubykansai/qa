require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  class Validation < self
    setup
    def setup_data
      @question = Question.new(:subject_id => 1, # subjects(:quentin_1),
                               :position => 10,
                               :body => "aaaaa")
    end

    def test_body_is_nil
      @question.body = nil
      assert_false(@question.valid?)
    end

    data("is nil" => nil,
         "is string" => "string",)
    def test_position(data)
      @question.position = data
      assert_false(@question.valid?)
    end

    def test_position_is_not_unique
      @other = @question.dup
      @other.save
      @question.position = 10
      assert_false(@question.valid?)
    end
  end

  class Relations < self
    setup
    def setup_data
      @user = FactoryGirl.create(:aaron)
      @subject = @user.subjects.first
      @question = @subject.questions.first
    end

    def test_belongs_to_subject
      assert_equal(Subject.first, @question.subject)
    end

    def test_belongs_to_question_type
      assert_equal(QuestionType.where(name: "select").first,
                   @question.question_type)
    end

    def test_has_many_choices
      assert_equal(Choice.all, @question.choices)
    end

    def test_has_many_answers
      assert_equal(Answer.all, @question.answers)
    end
  end
end
