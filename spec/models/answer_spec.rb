require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'mark_as_best' do
    before { answer.mark_as_best }

    it { expect(question.best_answer).to eq answer }
  end
end
