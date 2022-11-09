class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :question_id, :best

  def best
    object.best?
  end
end
