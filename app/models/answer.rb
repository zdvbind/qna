class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def unmark_as_best
    question.update(best_answer_id: nil)
  end

  def best?
    question.best_answer_id == id
  end
end
