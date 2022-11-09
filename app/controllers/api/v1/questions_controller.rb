class Api::V1::QuestionsController < Api::V1::BaseController
  skip_forgery_protection
  before_action :load_question, only: %i[show update]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: QuestionAdvancedSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, serializer: QuestionAdvancedSerializer, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, serializer: QuestionAdvancedSerializer, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
