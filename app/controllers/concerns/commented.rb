module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
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
end
