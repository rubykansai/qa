FactoryGirl.define do
  factory(:answer) do |m|
    m.body "body"
  end

  factory(:quentin_1_1_a1, parent: :answer) do |m|
    m.body "1"
    m.association :question, factory: :quentin_1_1
  end
  factory(:quentin_1_1_a2, parent: :answer) do |m|
    m.body "1"
    m.association :question, factory: :quentin_1_1
  end
  factory(:quentin_1_1_a3, parent: :answer) do |m|
    m.body "2"
    m.association :question, factory: :quentin_1_1
  end
  factory(:three, parent: :answer) do |m|
    m.body "MyText"
    m.association :question, factory: :quentin_1_3
  end
  factory(:four, parent: :answer) do |m|
    m.body "MyText"
    m.association :question, factory: :subject_holder_1_1
  end
  factory(:bug9_1_answer, parent: :answer) do |m|
    m.body "1"
    m.association :question, factory: :bug9_1_question
  end
  factory(:bug9_2_answer, parent: :answer) do |m|
    m.body "1"
    m.association :question, factory: :subject_holder_2_1
  end
  factory(:q_text, parent: :answer) do |m|
    m.body "Text"
    m.association :question, factory: :quentin_1_2
  end
end
