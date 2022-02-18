class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params.merge(author: current_user))

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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
end
