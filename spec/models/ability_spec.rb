require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :all_except_me, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other_user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create(:answer, question: other_question, author: other_user) }
    let(:link_question) { create(:link, linkable: question) }
    let(:link_answer) { create(:link, linkable: answer) }
    let(:link_other_question) { create(:link, linkable: other_question) }
    let(:link_other_answer) { create(:link, linkable: other_answer) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :me, User }

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'comment' do
      it { should be_able_to :comment, Question }
      it { should be_able_to :comment, Answer }
    end

    context 'best' do
      it { should be_able_to :best, answer }
      it { should_not be_able_to :best, create(:answer, question: other_question) }
    end

    context 'destroy' do
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :destroy, link_question }
      it { should be_able_to :destroy, link_answer }
      it { should_not be_able_to :destroy, link_other_answer }
      it { should_not be_able_to :destroy, link_other_question }
    end

    context 'vote' do
      it { should be_able_to %i[like dislike cancel], other_question }
      it { should_not be_able_to %i[like dislike cancel], question }
      it { should be_able_to %i[like dislike cancel], other_answer }
      it { should_not be_able_to %i[like dislike cancel], answer }
    end

    context 'subscribe' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, Subscription }
    end

    it { should be_able_to :destroy, ActiveStorage::Attachment }
  end
end
