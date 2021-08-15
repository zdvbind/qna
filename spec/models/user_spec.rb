require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'Check for the author' do
    let(:user_author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user_author) }

    it 'current user is the author' do
      expect(user_author).to be_author(question)
    end

    it 'current user is not the author' do
      expect(user).to_not be_author(question)
    end
  end
end
