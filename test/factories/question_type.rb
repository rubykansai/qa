FactoryGirl.define do
  factory(:question_type) do |m|
    m.name ""
  end
  factory(:select, parent: :question_type) do |m|
    m.name "select"
  end
  factory(:text, parent: :question_type) do |m|
    m.name "text"
  end
  factory(:ruby_select, parent: :question_type) do |m|
    m.name "ruby_select"
  end
  factory(:how_many_years, parent: :question_type) do |m|
    m.name "how_many_years"
  end
  factory(:how_many_times, parent: :question_type) do |m|
    m.name "how_many_times"
  end
  factory(:general_select, parent: :question_type) do |m|
    m.name "general_select"
  end
  factory(:fee_select, parent: :question_type) do |m|
    m.name "fee_select"
  end
end
