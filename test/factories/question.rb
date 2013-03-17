FactoryGirl.define do
  factory(:question) do |m|
    m.subject_id 1
    m.position 1
    m.body "body"
  end

  factory(:question_with_choice, parent: :question) do |m|
    m.choices{|c| (1..5).map{|n| c.association(:choice, position: n, body: "body #{n}") } }
    m.answers{|a| (1..5).map{|n| a.association(:answer, body: n.to_s) } }
  end

  factory(:quentin_1_1, parent: :question) do |m|
    m.association :subject, factory: :quentin_1
    m.position    1
    m.body        "MyText"
    m.association :question_type, factory: :select
  end
  factory(:quentin_1_2, parent: :question) do |m|
    m.association :subject, factory: :quentin_1
    m.position    2
    m.body        "MyText"
    m.association :question_type, factory:  "text"
  end
  factory(:quentin_1_3, parent: :question) do |m|
    m.association :subject, factory: :quentin_1
    m.position    3
    m.body        "MyText"
    m.association :question_type, factory: :text
  end
  factory(:subject_holder_1_1, parent: :question) do |m|
    m.association :subject, factory: :subject_holder_1
    m.position    1
    m.body        "MyText"
    m.association :question_type, factory: :text
  end
  factory(:subject_holder_3_1, parent: :question) do |m|
    m.association :subject, factory: :subject_holder_3
    m.position    1
    m.body        "MyText"
    m.association :question_type, factory: :text
  end
  factory(:bug9_1_question, parent: :question) do |m|
    m.association :subject, factory: :bug9
    m.position    1
    m.body        "text"
    m.association :question_type, factory: :how_many_years
  end
  factory(:bug9_2_question, parent: :question) do |m|
    m.association :subject, factory: :bug9
    m.position    2
    m.body        "text"
    m.association :question_type, factory: :how_many_times
  end
  factory(:answer_is_empty, parent: :question) do |m|
    m.association :subject, factory: :answer_id_empty
    m.position    1
    m.body        "text"
    m.association :question_type, factory: :ruby_select
  end
end
