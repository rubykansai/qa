# -*- coding: utf-8 -*-
require "test_helper"

class BatchControllerRollbackTest < ActionController::TestCase
  unregister_setup(:setup_db)
  unregister_teardown(:teardown_db)

  INVALID_DATA_WITHOUT_TITLE =<<EOD
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

  INVALID_DATA_WITHOUT_QUESTIONS =<<EOD
title: 第 27 回 Ruby/Rails 勉強会
start: 2008-05-22
end: 2008-07-10
max: 100
EOD

  INVALID_DATA_WITHOUT_QUESTION_BODY =<<EOD
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
  - question_type: text
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

  INVALID_DATA_WITHOUT_CHOICES_1 =<<EOD
title: 第 27 回 Ruby/Rails 勉強会
start: 2008-05-22
end: 2008-07-10
max: 100
questions:
  - body: Ruby ななにかについて
    question_type: select
    choices:
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

  INVALID_DATA_WITHOUT_CHOICES_2 =<<EOD
title: 第 27 回 Ruby/Rails 勉強会
start: 2008-05-22
end: 2008-07-10
max: 100
questions:
  - body: Ruby ななにかについて
    question_type: select
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


  sub_test_case("POST create by login user") do
    tests BatchController

    setup do
      DatabaseCleaner.clean_with(:truncation)
    end

    setup do
      load_question_types
      login_as(:quentin)
    end

   test "invalid subject" do
      post :create, :batch => { :body => INVALID_DATA_WITHOUT_TITLE }

      assert_equal('invalid data.', flash[:error])
      assert_redirected_to(subjects_path)
    end

    test "no questions" do
      post :create, :batch => { :body => INVALID_DATA_WITHOUT_QUESTIONS }

      assert_equal('posted data have no questions or choices.', flash[:error])
      assert_redirected_to(subjects_path)
    end

    test "a question is invalid" do
      mock(Choice).create!(anything()).times(4)
      post :create, :batch => { :body => INVALID_DATA_WITHOUT_QUESTION_BODY }

      assert_equal('invalid data.', flash[:error])
      assert_redirected_to(subjects_path)
    end

    test "no choices 1" do
      post :create, :batch => { :body => INVALID_DATA_WITHOUT_CHOICES_1 }

      assert_equal('posted data have no questions or choices.', flash[:error])
      assert_redirected_to(subjects_path)
    end

    test "no choices 2" do
      post :create, :batch => { :body => INVALID_DATA_WITHOUT_CHOICES_2 }

      assert_equal('posted data have no questions or choices.', flash[:error])
      assert_redirected_to(subjects_path)
    end
  end
end
