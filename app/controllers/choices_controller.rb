class ChoicesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @choices = Choice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @choices }
    end
  end

  def show
    @choice = Choice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  def new
    @choice = Choice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  def edit
    @choice = Choice.find(params[:id])
  end

  def create
    @choice = Choice.new(params[:choice])
    @question = Question.find(@choice.question_id)

    respond_to do |format|
      if @choice.save
        flash[:notice] = _('Choice was successfully created.')
        format.html {
          redirect_to(question_path(@choice.question_id))
        }
        format.xml  { render :xml => @choice, :status => :created, :location => @choice }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @choice = Choice.find(params[:id])

    respond_to do |format|
      if @choice.update_attributes(params[:choice])
        flash[:notice] = _('Choice was successfully updated.')
        format.html{
          redirect_to(question_path(@choice.question_id))
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy

    @choices = Choice.all(conditions: { question_id: @choice.question_id }, order: "position")
    @question = Question.find(@choice.question_id)
    respond_to do |format|
      format.html {
        redirect_to(question_path(@choice.question_id))
      }
      format.js
      format.xml  { head :ok }
    end
  end
end
