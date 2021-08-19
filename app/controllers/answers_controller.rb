class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def update
    answer.update(answer_params) if current_user&.author?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Question.new
  end

  helper_method :question, :answer
end
