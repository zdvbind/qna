module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save

    render 'comments/create'
  end

  private

  def model_class
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_class.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comment-#{load_question_id}",
                                 comment: @comment,
                                 email: current_user.email)
  end

  def load_question_id
    return @commentable.id if controller_name.eql?('questions')

    @commentable.question.id
  end
end
