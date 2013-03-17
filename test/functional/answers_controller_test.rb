require "test_helper"

class AnswersControllerTest < ActionController::TestCase

  def test_get_show_by_login_user
    login_as(:quentin)

    get :show, id: "4"
    assert_response :redirect
  end

  def test_get_show_by_anonymous_user
    @subject = FactoryGirl.build(:subject)
    mock(@subject).acceptable?.returns(true)
    mock(Subject).find('4').times(any_times).returns(@subject)

    get :show, id: '4'

    assert_response :success
    assert_template("answers/show")
    assert_equal(@subject.id, @request.session[:subject_id])
  end

  def test_get_show_when_the_subject_is_not_available
    @subject = FactoryGirl.build(:subject)
    mock(@subject).acceptable?.returns(false)
    mock(Subject).find('1').times(any_times).returns(@subject)

    get :show, :id => '1'

    assert_response :redirect
    assert_redirected_to(subjects_path)
  end

  def test_post_confirm_when_the_subject_is_available
    @question_type = FactoryGirl.build(:text)
    @subject = FactoryGirl.build(:subject)
    mock(@subject).acceptable?.returns(true)
    mock(Subject).find('4').times(any_times).returns(@subject)
    question_1 = FactoryGirl.build(:question, position: 1, question_type: @question_type)
    question_2 = FactoryGirl.build(:question, position: 2, question_type: @question_type)
    answer_1 = FactoryGirl.build(:answer, question: question_1)
    answer_2 = FactoryGirl.build(:answer, question: question_2)
    mock(Answer).new(question_id: '1', body: '1').returns(answer_1)
    mock(Answer).new(question_id: '2', body: 'bar').returns(answer_2)

    post(:confirm,
         :subject_id => '4',
         :answer => {
           :question_1 => '1',
           :question_2 => 'bar',
         })

    assert_response :success
    assert_template("answers/confirm")
  end

  def test_post_confirm_when_the_subject_is_not_available
    @subject = FactoryGirl.build(:subject)
    mock(@subject).acceptable?.returns(false)
    mock(Subject).find('4').times(any_times).returns(@subject)

    post(:confirm,
         :subject_id => '4',
         :answer => {
           :question_1 => '1',
           :question_2 => 'bar',
        })

    assert_response :redirect
    assert_redirected_to(subjects_path)
  end
end
