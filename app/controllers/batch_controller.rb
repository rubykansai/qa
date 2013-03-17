class BatchController < ApplicationController

  before_filter :authenticate_user!, :only => [:index, :new]

  # GET /batch/new
  # GET /batch/new.xml
  def new
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def index
    respond_to do |format|
      format.html{ redirect_to(:action => "new") }
      format.xml{ redirect_to(:action => "new") }
    end
  end

  # POST /batch
  # POST /batch.yaml
  def create
    error_message = ''
    if request.get?
      respond_to do |format|
        format.html{
          redirect_to(:controller => 'subjects', :action => 'index')
        }
        format.yaml{ render :text => _('posted data have no questions.') }
      end
      return
    end
    body = YAML.load(params[:batch][:body])
    login = body.delete("login")
    password = body.delete("password")
    raise PermissionError unless batch_logged_in?(login, password)
    @user = batch_current_user(current_user, login, password)
    @subject = nil
    @questions = []
    @choices = []
    ActiveRecord::Base.transaction do
      @subject = Subject.create!(:user_id => @user.id,
                                 :name => body.delete("title"),
                                 :start_date => body.delete("start"),
                                 :end_date => body.delete("end"),
                                 :max_respondents => body.delete("max"))
      questions = body.delete("questions")
      raise EmptyDataError if questions.nil? or questions.empty?
      questions.each_with_index do |question, index|
        question_type = QuestionType.where(:name => question["question_type"]).first
        @questions <<
          Question.create!(:subject_id => @subject.id,
                           :position => index + 1,
                           :body => question["body"],
                           :question_type_id => question_type.id)
        if 'select' == @questions.last.question_type.name
          choices = question["choices"]
          raise EmptyDataError if choices.nil? || choices.empty?
          choices.each_with_index do |choice, index|
            @choices << Choice.create!(:question_id => @questions.last.id,
                                       :position => index + 1,
                                       :body => choice)
          end
        end
      end
    end
    respond_to do |format|
      format.html{
        message = _('data was successfully created.')
        flash[:notice] = message
        redirect_to(:controller => 'subjects',
                    :action => 'show',
                    :id => @subject.id)
      }
      format.yaml{ render :text => message }
    end
  rescue PermissionError => ex
    error_message = _('permission denied.')
    logger.debug(error_message)
  rescue EmptyDataError => ex
    error_message = _('posted data have no questions or choices.')
    logger.debug(error_message)
  rescue ActiveRecord::RecordInvalid => ex
    error_message = _('invalid data.')
    logger.debug(error_message)
    logger.debug(ex.message)
    logger.debug(ex.backtrace)
  rescue StandardError => ex
    error_message = _('something wrong.')
    logger.debug(error_message)
    logger.debug(ex.message)
    logger.debug(ex.backtrace)
  ensure
    unless error_message.blank?
      flash[:error] = error_message
      respond_to do |format|
        format.html{
          redirect_to(:controller => 'subjects', :action => 'index')
        }
        format.yaml{ render :text => error_message }
      end
    end
  end

  private
  def batch_logged_in?(login, password)
    user_signed_in? or !! User.authenticate(login, password)
  end

  def batch_current_user(current_user, login, password)
    if user_signed_in?
      current_user
    else
      User.authenticate(login, password)
    end
  end
end
