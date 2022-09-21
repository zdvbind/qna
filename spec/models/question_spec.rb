require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:best_answer).class_name('Answer').optional }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
