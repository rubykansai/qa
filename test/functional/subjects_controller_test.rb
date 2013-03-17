require "test_helper"

class SubjectsControllerTest < ActionController::TestCase

  def test_get_index_by_login_user
    @attributes = {
      :id => 1,
      :user_id => 1,
      :name => 'string',
      :start_date => Date.today,
      :end_date => Date.today,
      :max_respondents => 100,
    }
    subjects = (1..10).map{|n| FactoryGirl.build(:subject, id: n) }
    mock(Subject).all(order: "start_date", include: :user).returns(subjects)

    login_as(:quentin)
    get :index

    assert_response :success
    assert_not_nil(assigns(:subjects))
    assert_template("subjects/index")
  end

  def test_get_show_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    mock(Subject).find(@subject.id.to_s){ @subject }
    mock(Question).all(conditions: { subject_id: @subject.id },
                       order: "position").returns([])

    login_as(:quentin)
    get :show, id: @subject

    assert_response :success
    assert_template("subjects/show")
  end

  def test_get_show_by_anonymous_user
    @subject = FactoryGirl.build(:subject, id: 1)
    mock(Subject).find(@subject.id.to_s){ @subject }

    get :show, id: @subject

    assert_response :success
    assert_template("subjects/show_anonymous")
  end

  def test_get_new_by_login_user
    login_as(:quentin)

    get :new

    assert_response :success
    assert_template("subjects/new")
  end

  def test_get_new_by_anonymous_user
    get :new

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_get_edit_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    mock(Subject).where(anything()){ [@subject] }

    login_as(:quentin)
    get :edit, id: @subject

    assert_response :success
  end

  def test_get_edit_by_anonymous_user
    get :edit, id: "1"

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end

  def test_post_create_by_login_user
    @subject = FactoryGirl.build(:subject, id: 1)
    mock(@subject).user_id=(anything())
    mock(@subject).save{ true }
    mock(Subject).new(anything()){ @subject }

    login_as(:quentin)
    post(:create,
         :subject => {
           :user_id         => 1,
           :name            => 'title',
           :start_date      => Date.new(2008,1,1),
           :end_date        => Date.new(2008,1,1),
           :max_respondents => 1,
         })

    assert_response :redirect
    assert_redirected_to(subjects_path)
  end

  def test_post_create_by_anonymous_user
    post(:create,
         :subject => {
           :user_id         => 1,
           :name            => 'title',
           :start_date      => Date.new(2008,1,1),
           :end_date        => Date.new(2008,1,1),
           :max_respondents => 1,
         })

    assert_response :redirect
    assert_redirected_to(new_user_session_path)
  end
end
