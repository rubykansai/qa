class QuestionsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @choices = Choice.all(conditions: { question_id: @question.id }, order: "position")
  end

  def new
    @question = Question.new
    @question.subject = Subject.find(params[:subject_id])
  end

  def edit
    @question = Question.find(params[:id])
    raise PermissionError unless permitted?
  end

  def create
    @question = Question.new(params[:question])
    @subject = Subject.find(@question.subject_id)

    respond_to do |format|
      if @question.save
        flash[:notice] = _('Question was successfully created.')
        format.html{
          redirect_to(subject_path @subject)
        }
        format.js{
          render :update do |page|
            page.visual_effect :grow, "question_#{@question.id}", :duration => 0.6
            page.insert_html :bottom, 'question_list', :partial => 'questions/question'
          end
        }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    # OPTIMIZE
    @question = Question.find(params[:id])
    raise PermissionError unless permitted?

    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:notice] = _('Question was successfully updated.')
        format.html{
          redirect_to(:controller => 'subjects',
                      :action => 'show',
                      :id => @question.subject_id)
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    raise PermissionError unless permitted?
    @question.destroy
    @subject = @question.subject
    @questions = @subject.questions
    respond_to do |format|
      format.html {
        redirect_to(:controller => 'subjects',
                    :action => 'show',
                    :id => @question.subject_id)
      }
      format.js
    end
  end

  private

  def permitted?
    current_user.id == @question.subject.user.id
  end
end
