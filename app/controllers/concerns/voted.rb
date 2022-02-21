module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[like dislike cancel]
  end

  def like
    return render_errors if current_user&.author?(@votable)

    @votable.like(current_user)
    render_json
  end

  def dislike
    return render_errors if current_user.author?(@votable)

    @votable.dislike(current_user)
    render_json
  end

  def cancel
    return render_errors if current_user.author?(@votable)

    @votable.cancel(current_user)
    render_json
  end

  private

  def render_errors
    render json: { message: "You're an author, or not authorized" },
           status: 422
  end

  def render_json
    render json: { rating: @votable.rating,
                   resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
