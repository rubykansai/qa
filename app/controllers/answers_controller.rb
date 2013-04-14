class AnswersController < ApplicationController
  before_filter :answer?, only: %w[show confirm create]
  cache_sweeper :graph_sweeper, only: [:create]

  def show
    @subject = Subject.find(params[:id])
    @questions = @subject.questions
    session[:subject_id] = @subject.id
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def confirm
    @answers = answers(params[:answer])
    respond_to do |format|
      if @answers.all?{|answer| answer.valid? }
        format.html # confirm.html.erb
      else
        format.html{ render :action => 'show'}
      end
    end
  end

  def create
    subject_id = session[:subject_id]
    @answers = answers(params[:answer])
    @answer_counter = AnswerCounter.new(:subject_id => subject_id)
    Answer.transaction do
      @answers.each(&:save!)
      @answer_counter.save!
    end
    flash[:notice] = _('Answers were successfully created.')
  rescue Exception => e # FIXME
    flash[:error] = _('maybe something wrong.')
    raise
  ensure
    respond_to do |format|
      format.html{
        redirect_to answer_path(subject_id)
      }
    end
  end

  def summary
    @subject = Subject.find(params[:id])
    @questions = Question.find_all_by_subject_id(@subject.id, :order => "position")
    # [[question, answers], ...]
    @answers = @questions.zip @questions.map{|question|
      case question.question_type.name
      when /select/, /how_many/
        Answer.summary(question.id)
      when /text/
        Answer.find(:all, :conditions => ['question_id = ?', question.id])
      else
        raise 'must not happen!'
      end
    }
    respond_to do |format|
      format.html # summary.html.erb
      format.xml  # summary.xml.erb ???
    end
  end

  private

  def answers(hash)
    # OPTIMIZE this method sends 5 times or more queries
    hash.map{|key, val|
      Answer.new(:question_id => key.split('_')[1], :body => val)
    }.sort_by{|answer|
      answer.question.position
    }
  end

  def answer?
    if user_signed_in?
      respond_to do |format|
        format.html{ redirect_to(subjects_path) }
      end
      return false
    end
    subject = Subject.find(params[:id] || params[:subject_id] || session[:subject_id])
    unless subject.acceptable?
      flash[:error] = _('You cannot fill in this questionnaire.')
      respond_to do |format|
        format.html{ redirect_to(subjects_path) }
      end
      return false
    end
    true
  end
end
