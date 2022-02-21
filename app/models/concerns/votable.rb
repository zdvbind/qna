module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def like(user)
    votes.create!(user: user, value: 1) unless vote_exists?(user)
  end

  def dislike(user)
    votes.create!(user: user, value: -1) unless vote_exists?(user)
  end

  def cancel(user)
    votes.find_by(user: user)&.destroy
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote_exists?(user)
    votes.exists?(user: user)
  end
end
