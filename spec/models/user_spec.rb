require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:awards).dependent(:nullify) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  # describe 'Check for the author' do
  describe 'Check for the user' do
    let(:user_author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user_author) }

    context 'author of the question' do
      it 'current user is the author' do
        expect(user_author).to be_author(question)
      end

      it 'current user is not the author' do
        expect(user).to_not be_author(question)
      end
    end

    context 'subscriber of the question' do
      let(:subscription) { create(:subscription, user: user_author, question: question) }

      it 'current user is the subscriber' do
        expect(user_author).to be_subscribed(question)
      end

      it 'current user is not the subscriber' do
        expect(user).to_not be_subscribed(question)
      end
    end
  end
end
