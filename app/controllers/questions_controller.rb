class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new

    gon.push({question_id: @question.id})
  end

  def new
    @question = current_user.questions.new
    @question.build_award
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.best_answer&.unmark_as_best
      @question.destroy
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: %i[name url _destroy],
                                     award_attributes: %i[name image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', @question)
  end
end
