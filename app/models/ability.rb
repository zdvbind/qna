# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :all_except_me, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], { user_id: user.id }
    can :comment, [Question, Answer]
    can :destroy, Link, linkable: { user_id: user.id }
    can :best, Answer, question: { user_id: user.id }

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end

    can %i[like dislike cancel], [Question, Answer] do |votable|
      votable.user_id != user.id
    end
    can :me, User
  end
end
