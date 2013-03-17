class SubjectsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @subjects = Subject.all(order: "start_date", include: :user)
  end

  def show
    @subject = Subject.find(params[:id])
    if user_signed_in?
      @questions = Question.all(conditions: { subject_id: @subject.id }, order: "position")
    else
      respond_to do |format|
        format.html { render template: 'subjects/show_anonymous' }
      end
    end
  end

  def new
    @subject = Subject.new
  end

  def edit
    @subject = Subject.where(id: params[:id], user_id: current_user.id).first
    raise PermissionError if @subject.nil?
  end

  def create
    @subject = Subject.new(params[:subject])
    @subject.user_id = current_user.id

    respond_to do |format|
      if @subject.save
        format.html { redirect_to(@subject, notice: _('Subject was successfully created.')) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @subject = Subject.where(:id => params[:id], :user_id => current_user.id).first
    raise PermissionError if @subject.nil?

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        flash[:notice] = _('Subject was successfully updated.')
        format.html { redirect_to(@subject) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.xml
  def destroy
    @subject = Subject.where(:id => params[:id], :user_id => current_user.id).first
    raise PermissionError if @subject.nil?
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to(subjects_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  def add_question
    @question = Question.new(params[:question])
    @subject = Subject.find(@question.subject_id)

    respond_to do |format|
      if @question.save
        format.html{
          redirect_to(:controller => 'subjects',
                      :action => 'show',
                      :id => @question.subject_id
                      )
        }
      else
        format.html{ render :action => 'show', :id => @subject.id}
      end
    end
  end
end
