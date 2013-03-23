require "test_helper"

class QuestionsControllerTest < ActionController::TestCase

  sub_test_case("GET index") do
    tests QuestionsController

    def test_by_login_user
      login_as(:quentin)
      get :index

      assert_response :success
      assert_template("questions/index")
    end
  end

  def test_get_show_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    @question_type = FactoryGirl.build(:select)
    @question = FactoryGirl.build(:question,
                                  id: 1,
                                  subject: @subject,
                                  question_type: @question_type)
    mock(Question).find(anything()){ @question }
    mock(Choice).all(anything()){ [] }

    login_as(:quentin)
    get :show, id: @question.id

    assert_response :success
    assert_template("questions/show")
  end

  def test_get_show_by_anonymous_user
    get :show, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_new_by_login_user
    subject = FactoryGirl.build(:subject, id: 1)
    mock(Subject).find(anything()){ subject }

    login_as(:quentin)
    get :new, subject_id: subject.id

    assert_response :success
    assert_template("questions/new")
  end

  def test_get_new_by_anonymous_user
    get :new, subject_id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_edit_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    @question = FactoryGirl.build(:question, id: 1, subject: @subject)
    mock(Question).find(anything()).returns(@question)
    mock(@controller).permitted?{ true }

    login_as(:quentin)
    get :edit, id: @question.id

    assert_response :success
    assert_template("questions/edit")
  end

  # def test_get_edit_by_login_user_other
  #   @another = mock_model(User, :id => 2)
  #   @subject = mock_model(Subject, :user => @user)
  #   @question = mock_model(Question, :subject => @subject)
  #   Question.should_receive(:find).with(anything()).and_return(@question)

  #   login_as(@anonther)
  #   get :edit, id: 1 # raise PermissionError
  # end

  def test_get_edit_by_anonymous_user
    get :edit, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_post_create_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    mock(Subject).find(@subject.id){ @subject }

    login_as(:quentin)
    post(:create,
         :question => {
           :subject_id => @subject.id,
           :position => 3,
           :body => 'test',
           :question_type_id => 2,
         })

    assert_response :redirect
    assert_redirected_to(subject_path(@subject))
  end

  def test_post_create_by_anonymous_user
    post(:create,
         :question => {
           :subject_id => 1,
           :position => 3,
           :body => 'test',
           :question_type_id => 2,
         })

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_put_update_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    @question = FactoryGirl.build(:question, id: 1, subject: @subject)
    mock(Question).find(@question.id.to_s){ @question }
    mock(@controller).permitted?{ true }

    login_as(:quentin)
    put(:update,
        :id => @question.id,
        :question => {
          :position => 1,
          :subject_id => @subject.id,
          :body => 'aaa',
        })

    assert_response :redirect
    assert_redirected_to(subject_path(@subject))
  end

  def test_put_update_by_anonymous_user
    put(:update,
        :id => 1,
        :question => {
          :position => 1,
          :subject_id => 1,
          :body => 'aaa',
        })

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_delete_destroy_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    @question = FactoryGirl.build(:question, id: 1, subject: @subject)
    mock(Question).find(@question.id.to_s){ @question }
    mock(@controller).permitted?{ true }

    login_as(:quentin)
    delete :destroy, id: @question.id

    assert_response :redirect
    assert_redirected_to(subject_path(@subject))
  end

  def test_delete_destroy_by_anonymous_user
    delete :destroy, id: 1

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end
end
