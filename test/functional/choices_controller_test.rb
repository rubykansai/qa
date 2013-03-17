require "test_helper"

class ChoicesControllerTest < ActionController::TestCase

  def test_get_index_by_login_user
    login_as(:quentin)
    get :index

    assert_response :success
    assert_template("choices/index")
  end

  def test_get_index_by_anonymous_user
    get :index

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_show_by_login_user
    @choice = FactoryGirl.create(:choice)

    login_as(:quentin)
    get :show, id: @choice.id

    assert_response :success
    assert_template("choices/show")
  end

  def test_get_show_by_anonymous_user
    get :show, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_new_by_login_user
    login_as(:quentin)
    get :new, id: 1

    assert_response :success
    assert_template("choices/new")
  end

  def test_get_new_by_anonymous_user
    get :new, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_edit_by_login_user
    @choice = FactoryGirl.build(:choice, id: 1)
    mock(Choice).find(anything()){ @choice }

    login_as(:quentin)
    get :edit, id: @choice.id

    assert_response :success
    assert_template("choices/edit")
  end

  def test_get_edit_by_anonymous_user
    get :edit, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_post_create_by_login_user_success_on_save
    @question = FactoryGirl.build(:question, id: 1)
    @choice = FactoryGirl.build(:choice, question: @question)
    mock(@choice).save{ true }
    mock(Choice).new(anything()){ @choice }
    mock(Question).find(anything()){ @question }

    login_as(:quentin)
    post :create, choice: {}

    assert_response :redirect
    assert_redirected_to(question_path(@question))
  end

  def test_post_create_by_login_user_fail_on_save
    @question = FactoryGirl.build(:question, id: 1)
    @choice = FactoryGirl.build(:choice, question: @question)
    mock(@choice).save{ false }
    mock(Choice).new(anything()){ @choice }
    mock(Question).find(anything()){ @question }

    login_as(:quentin)
    post :create, choice: {}

    assert_response :success
    assert_template("choices/new")
  end

  def test_post_create_by_anonymous_user
    post :create, choice: {}

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_delete_by_login_user
    @user = login_as(:aaron)
    @choice = @user.subjects.first.questions.first.choices.first
    delete :destroy, id: @choice.id

    assert_response :redirect
    assert_redirected_to(question_path(@choice.question.id))
  end

  def test_delete_by_anonymous_user
    delete :destroy, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end
end
