FactoryGirl.define do
  factory(:answer_counter) do |m|
    m.subject_id 1
  end

  factory(:counter_quentin_1_1, parent: :answer_counter) do |m|
    m.association :subject, factory: :quentin_1
  end
  factory(:counter_quentin_1_2, parent: :answer_counter) do |m|
    m.association :subject, factory: :quentin_1
  end
  factory(:counter_quentin_1_3, parent: :answer_counter) do |m|
    m.association :subject, factory: :quentin_1
  end
end
