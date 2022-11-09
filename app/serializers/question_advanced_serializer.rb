class QuestionAdvancedSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :best_answer_id, :user_id, :comments, :links, :files

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
