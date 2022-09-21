class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question-#{params[:question_id]}"
  end
end
