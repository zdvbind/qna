class AnswersController < ApplicationController
  def new; end

  def show; end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
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
