FactoryGirl.define do
  factory(:choice) do |m|
    m.question_id 1
    m.position 1
    m.body "body"
  end
  factory(:quentin_1_1_1, parent: :choice) do |m|
    m.position 1
    m.body "MyText"
    m.association :question, factory: :quentin_1_1
  end
  factory(:quentin_1_1_2, parent: :choice) do |m|
    m.position 2
    m.body "MyText"
    m.association :question, factory: :quentin_1_1
  end
  factory(:bug9_1_choice, parent: :choice) do |m|
    m.position 1
    m.body "MyText"
    m.association :question, factory: :bug9_1_question
  end
  factory(:bug9_2_choice, parent: :choice) do |m|
    m.position 2
    m.body "MyText"
    m.association :question, factory: :bug9_1_question
  end
  factory(:bug9_3_choice, parent: :choice) do |m|
    m.position 1
    m.body "MyText"
    m.association :question, factory: :bug9_2_choice
  end
  factory(:bug9_4_choice, parent: :choice) do |m|
    m.position 2
    m.body "MyText"
    m.association :question, factory: :bug9_2_question
  end
end
