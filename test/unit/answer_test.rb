require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  def test_summpary
    @summary = Answer.summary(FactoryGirl.create(:question_with_choice).id)
    assert_equal(5, @summary.size)
    summary = @summary.map{|v| v.attributes.symbolize_keys }.sort_by{|v| v[:body] }
    expected =[
               { body: "1", count: "1", label: "body 1"},
               { body: "2", count: "1", label: "body 2"},
               { body: "3", count: "1", label: "body 3"},
               { body: "4", count: "1", label: "body 4"},
               { body: "5", count: "1", label: "body 5"},
              ]
    assert_equal(expected, summary)
  end
end
