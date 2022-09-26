class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comment-#{params[:question_id]}"
  end
end