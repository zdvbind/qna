class AnswerAdvancedSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best, :user_id, :comments, :links, :files, :question_id

  def best
    object.best?
  end

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
  end
end
