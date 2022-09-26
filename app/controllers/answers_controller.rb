class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  def create
    @answer = question.answers.new(answer_params.merge(author: current_user))
    @answer.save
  end

  def destroy
    return unless current_user.author?(answer)

    answer.unmark_as_best if answer.best?
    answer.destroy
  end

  def update
    answer.update(answer_params) if current_user&.author?(answer)
    @question = answer.question
  end

  def best
    @question = answer.question
    answer.mark_as_best if current_user.author?(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Question.new
  end

  helper_method :question, :answer

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("question-#{@answer.question.id}", @answer)
  end
end
