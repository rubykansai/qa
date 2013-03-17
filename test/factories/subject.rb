FactoryGirl.define do
  factory(:subject) do |m|
    m.user_id         1
    m.name            "name"
    m.start_date      Date.today
    m.end_date        Date.today
    m.max_respondents 100
  end

  factory(:subject_with_question, parent: :subject) do |m|
    m.questions{|s| [s.association(:question_with_choice)] }
  end

  factory(:quentin_1, parent: :subject) do |m|
    m.association     :user, factory: :quentin
    m.name            "MyString"
    m.start_date      Date.parse("2008-01-20")
    m.end_date        Date.parse("2008-01-20")
    m.max_respondents 1
  end
  factory(:quentin_2, parent: :subject) do |m|
    m.association     :user, factory: :quentin
    m.name            "MyString"
    m.start_date      Date.parse("2008-01-20")
    m.end_date        Date.parse("2008-01-20")
    m.max_respondents 1
  end
  factory(:subject_holder_1, parent: :subject) do |m|
    m.association     :user, factory: :subject_holder
    m.name            "MyString"
    m.start_date      Date.parse("2008-01-20")
    m.end_date        Date.parse("2008-01-20")
    m.max_respondents 1
  end
  factory(:subject_holder_2, parent: :subject) do |m|
    m.association     :user, factory: :subject_holder
    m.name            "MyString"
    m.start_date      Date.today
    m.end_date        Date.today
    m.max_respondents 10
  end
  factory(:subject_holder_3, parent: :subject) do |m|
    m.association     :user, factory: :subject_holder
    m.name            "MyString"
    m.start_date      Date.today
    m.end_date        Date.today
    m.max_respondents 1
  end
end
