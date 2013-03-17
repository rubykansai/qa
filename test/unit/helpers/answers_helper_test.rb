require "test_helper"

class AnswersHelperTest < ActionView::TestCase

  data("select"         => "select",
       "ruby_select"    => "ruby_select",
       "how_many_years" => "how_many_years",
       "how_many_times" => "how_many_times",
       "general_select" => "general_select",
       "fee_select"     => "fee_select")
  def test_question_tag(data)
    name = data
    question_type = FactoryGirl.build(:question_type, name: name)
    question = FactoryGirl.build(:question, id: 42, question_type: question_type)
    choices = (1..5).map{|n|
      FactoryGirl.build(:choice,
                        id: n,
                        question: question,
                        position: n,
                        body: "choice #{n}")
    }
    mock(Choice).all(anything()){ choices }

    render text: question_tag(question)

    assert_select("ul.choice-list") do
      choices.each do |choice|
        assert_select("li input#answer_question_42_#{choice.position}[type=radio]")
        assert_select("li label", choice.body)
      end
    end
  end

  def test_question_tag_text
    question_type = FactoryGirl.build(:text)
    question = FactoryGirl.build(:question, question_type: question_type)
    mock(Choice).all(anything()).times(0)

    render text: question_tag(question)

    assert_select("br")
    assert_select("textarea")
  end

  data("select"         => "select",
       "ruby_select"    => "ruby_select",
       "how_many_years" => "how_many_years",
       "how_many_times" => "how_many_times",
       "general_select" => "general_select",
       "fee_select"     => "fee_select")
  def test_confirm_tag(data)
    name = data
    question_type = FactoryGirl.build(:question_type, name: name)
    question = FactoryGirl.build(:question, id: 42, question_type: question_type)
    answer = FactoryGirl.build(:answer,
                               question: question,
                               question_id: question.id,
                               body: "1")
    choices = (1..5).map{|n|
      FactoryGirl.build(:choice,
                        id: n,
                        question: question,
                        position: n,
                        body: "choice #{n}")
    }
    mock(Choice).all(anything()){ choices }

    render text: confirm_tag(answer)

    assert_select("ul li", choices.first.body)
  end

  def test_confirm_tag_text
    question_type = FactoryGirl.build(:text)
    question = FactoryGirl.build(:question, question_type: question_type)
    answer = FactoryGirl.build(:answer,
                               question: question,
                               question_id: question.id,
                               body: "1")
    mock(Choice).all(anything()).times(0)

    render text: confirm_tag(answer)

    assert_select("div", answer.body)
  end
end
