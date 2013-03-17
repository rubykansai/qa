require "test_helper"

class QuestionsHelperTest < ActionView::TestCase

  def test_select_question_type
    question_types = ["select", "text", "ruby_select", "how_many_years",
                       "how_many_times", "general_select", "fee_select"]
    records = question_types.each.with_index.map{|label,  index|
      FactoryGirl.build(label, :id => index + 1)
    }
    mock(QuestionType).all.with(:select => 'id, name', :order => 'id'){ records }
    render text:  select_question_type

    assert_select "select" do
      question_types.each.with_index do |label, index|
        assert_select("option[value=#{index + 1}]", label)
      end
    end
  end

  data("text"           => ["text"           , false],
       "select"         => ["select"         , true],
       "ruby_select"    => ["ruby_select"    , true],
       "how_many_years" => ["how_many_years" , true],
       "how_many_times" => ["how_many_times" , true],
       "general_select" => ["general_select" , true],
       "fee_select"     => ["fee_select"     , true])
  def test_show_choice_block?(data)
    target, expected = data
    question_type = FactoryGirl.build(:question_type, name: target)
    question = FactoryGirl.build(:question,
                                 question_type: question_type)

    assert_equal(expected, show_choice_block?(question))
  end

  def test_explain_question_type
    question_types = ["ruby_select", "how_many_years",
                      "how_many_times", "general_select", "fee_select"]
    records = question_types.each.with_index.map{|name,  index|
      FactoryGirl.build(:question_type, id: index + 1, name: name)
    }
    mock(QuestionType).all(anything()){ records }

    actual = explain_question_type

    assert_equal(5, actual.size)
    assert_equal(question_types.sort, actual.map(&:first).sort)
  end
end
