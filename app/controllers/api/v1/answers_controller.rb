class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: :show

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer, serializer: AnswerAdvancedSerializer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_resource_owner))
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
