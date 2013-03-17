require "test_helper"

class ChoiceTest < ActiveSupport::TestCase
  setup
  def setup_data
    @choice = Choice.new(question_id: 1,
                         position: 1,
                         body: "body")
  end

  def test_is_empty
    assert_false(Choice.new.valid?)
  end
end
