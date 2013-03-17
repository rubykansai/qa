# -*- coding: utf-8 -*-
require "test_helper"

class BatchControllerTest < ActionController::TestCase

  VALID_DATA_WITHOUT_USER_INFO =<<EOD
title: 第 27 回 Ruby/Rails 勉強会
start: 2008-05-22
end: 2008-07-10
max: 100
questions:
  - body: Ruby ななにかについて
    question_type: select
    choices:
      - あ
      - い
      - う
      - え
  - body: もうひとつの質問
    question_type: text
  - body: 司会について
    question_type: select
    choices:
      - いまいち
      - ふつう
      - よかった
      - 無回答
  - body: 参加費について
    question_type: select
    choices:
      - 安い
      - 普通
      - 高い
      - 無回答
  - body: Ruby ななにかについて
    question_type: ruby_select
  - body: Ruby 歴は？
    question_type: how_many_years
  - body: Ruby 勉強会の参加回数は？
    question_type: how_many_times
EOD

  VALID_DATA_WITH_USER_INFO =<<EOD
login: quentin@example.com
password: monkey
title: 第 27 回 Ruby/Rails 勉強会
start: 2008-05-22
end: 2008-07-10
max: 100
questions:
  - body: Ruby ななにかについて
    question_type: select
    choices:
      - あ
      - い
      - う
      - え
  - body: もうひとつの質問
    question_type: text
  - body: 司会について
    question_type: select
    choices:
      - いまいち
      - ふつう
      - よかった
      - 無回答
  - body: 参加費について
    question_type: select
    choices:
      - 安い
      - 普通
      - 高い
      - 無回答
  - body: Ruby ななにかについて
    question_type: ruby_select
  - body: Ruby 歴は？
    question_type: how_many_years
  - body: Ruby 勉強会の参加回数は？
    question_type: how_many_times
EOD

  def test_post_create_by_login_user_when_posted_data_is_valid
    @original_subjects_count = Subject.count
    @original_questions_count = Question.count
    @original_choices_count = Choice.count
    load_question_types

    login_as(:quentin)
    post :create, :batch => { :body => VALID_DATA_WITHOUT_USER_INFO }
    @subject = assigns(:subject)
    @questions = @subject.questions

    assert_equal(@original_subjects_count + 1, Subject.count)

    expected = {
      "name"            => '第 27 回 Ruby/Rails 勉強会',
      "start_date"      => Date.parse('2008-05-22'),
      "end_date"        => Date.parse('2008-07-10'),
      "max_respondents" => 100,
    }
    actual = {
      "name"            => @subject.name,
      "start_date"      => @subject.start_date,
      "end_date"        => @subject.end_date,
      "max_respondents" => @subject.max_respondents,
    }
    assert_equal(expected, actual)

    assert_equal(@original_questions_count + 7, Question.count)
    questions = YAML.load <<EOD
- body: Ruby ななにかについて
  question_type: select
  subject_id: #{@subject.id}
- body: もうひとつの質問
  question_type: text
  subject_id: #{@subject.id}
- body: 司会について
  question_type: select
  subject_id: #{@subject.id}
- body: 参加費について
  question_type: select
  subject_id: #{@subject.id}
- body: Ruby ななにかについて
  question_type: ruby_select
  subject_id: #{@subject.id}
- body: Ruby 歴は？
  question_type: how_many_years
  subject_id: #{@subject.id}
- body: Ruby 勉強会の参加回数は？
  question_type: how_many_times
  subject_id: #{@subject.id}
EOD
    @questions.zip(questions).each do |question, expected|
      actual = {
        "body" => question.body,
        "question_type" => question.question_type.name,
        "subject_id" => question.subject_id
      }
      assert_equal(actual, expected)
    end
    assert_equal(@original_choices_count + 31, Choice.count)
    actual_position = @questions.reject{|question|
      question.question_type.name == "text"
    }.map(&:position).sort.first
    assert_equal(1, actual_position)
    assert_false(flash[:notice].empty?)
    assert_redirected_to(subject_path(@subject.id))
  end

  def test_post_create_by_anonymous_user_posted_data_with_user_password
    load_question_types
    user = FactoryGirl.create(:quentin)
    @original_subjects_count = Subject.count
    @original_questions_count = Question.count
    @original_choices_count = Choice.count

    post :create, :batch => { :body => VALID_DATA_WITH_USER_INFO }
    @subject = assigns(:subject)
    @questions = @subject.questions

    assert_equal(@original_subjects_count + 1, Subject.count)
    expected = {
      "name"            => '第 27 回 Ruby/Rails 勉強会',
      "start_date"      => Date.parse('2008-05-22'),
      "end_date"        => Date.parse('2008-07-10'),
      "max_respondents" => 100,
    }
    actual = {
      "name"            => @subject.name,
      "start_date"      => @subject.start_date,
      "end_date"        => @subject.end_date,
      "max_respondents" => @subject.max_respondents,
    }
    assert_equal(expected, actual)

    assert_equal(@original_questions_count + 7, Question.count)
    questions = YAML.load <<EOD
- body: Ruby ななにかについて
  question_type: select
  subject_id: #{@subject.id}
- body: もうひとつの質問
  question_type: text
  subject_id: #{@subject.id}
- body: 司会について
  question_type: select
  subject_id: #{@subject.id}
- body: 参加費について
  question_type: select
  subject_id: #{@subject.id}
- body: Ruby ななにかについて
  question_type: ruby_select
  subject_id: #{@subject.id}
- body: Ruby 歴は？
  question_type: how_many_years
  subject_id: #{@subject.id}
- body: Ruby 勉強会の参加回数は？
  question_type: how_many_times
  subject_id: #{@subject.id}
EOD
    @questions.zip(questions).each do |question, expected|
      actual = {
        "body" => question.body,
        "question_type" => question.question_type.name,
        "subject_id" => question.subject_id
      }
      assert_equal(actual, expected)
    end

    assert_equal(@original_choices_count + 31, Choice.count)
    actual_position = @questions.reject{|question|
      question.question_type.name == "text"
    }.map(&:position).sort.first
    assert_equal(1, actual_position)
    assert_false(flash[:notice].empty?)
    assert_redirected_to(subject_path(@subject.id))
  end

  def test_post_create_by_anonymous_user_posted_data_without_user_password
    load_question_types
    @original_subjects_count = Subject.count
    @original_questions_count = Question.count
    @original_choices_count = Choice.count

    post :create, :batch => { :body => VALID_DATA_WITHOUT_USER_INFO }

    assert_equal(@original_subjects_count, Subject.count)
    assert_equal(@original_questions_count, Question.count)
    assert_equal(@original_choices_count, Choice.count)

    assert_redirected_to(subjects_path)
  end

  def test_get_create
    get :create
    assert_redirected_to(subjects_path)
  end
end

