require "test_helper"

class SubjectTest < ActiveSupport::TestCase

  class InvalidData < self
    setup
    def setup_data
      @subject = Subject.new(:user_id         => 1, # users(:quentin).id,
                             :name            => 'aaa',
                             :start_date      => Date.today,
                             :end_date        => Date.today,
                             :max_respondents => 100)
    end

    def test_empty
      assert_false(Subject.new.valid?)
    end

    data(:user_id    => :user_id,
         :start_date => :start_date,
         :end_date   => :end_date)
    def test_an_attribute_is_empty(data)
      @subject.__send__("#{data}=", nil)
      assert_false(@subject.valid?)
    end

    def test_max_respondents_is_not_integer
      @subject.max_respondents = "aaa"
      assert_false(@subject.valid?)
    end
  end

  class Relation < self
    def test_has_many_questions
      @subject = FactoryGirl.create(:subject)
      @expected =
        [
         FactoryGirl.create(:question, subject: @subject, position: 1),
         FactoryGirl.create(:question, subject: @subject, position: 2),
         FactoryGirl.create(:question, subject: @subject, position: 3),
        ]
      assert_equal(@expected, @subject.questions.all(order: "position ASC"))
    end

    def test_belongs_to_user
      @quentin = FactoryGirl.create(:quentin)
      @subject = FactoryGirl.create(:subject, user: @quentin)
      assert_equal(@quentin, @subject.user)
    end
  end

end
