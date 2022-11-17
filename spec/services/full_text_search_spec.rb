require 'sphinx_helper'

RSpec.describe FullTextSearch do
  let(:user_author) { create(:user) }
  let!(:question) { create(:question, author: user_author) }
  let!(:answer) { create(:answer, author: user_author) }
  let!(:comment) { create(:comment, user: user_author, commentable: question) }
  let(:some_user) { create(:user) }

  subject { FullTextSearch.new(params) }

  context 'User find the question' do
    let!(:params) { { type: 'Questions', request: question.body } }
    let(:result) { subject.call }

    it 'returns array with question', sphinx: true do
      ThinkingSphinx::Test.run do
        sleep(0.25)
        expect(result.first.body).to eq question.body
      end
    end
  end

  context 'User find the answer' do
    let!(:params) { { type: 'Answers', request: answer.body } }
    let(:result) { subject.call }

    it 'returns array with answer', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result.first.body).to eq answer.body
      end
    end
  end

  context 'User find the comment' do
    let!(:params) { { type: 'Comments', request: comment.body } }
    let(:result) { subject.call }

    it 'returns array with comment', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result.first.body).to eq comment.body
      end
    end
  end

  context 'User find the user' do
    let!(:params) { { type: 'Users', request: some_user.email } }
    let(:result) { subject.call }

    it 'returns array with user', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result.first.email).to eq some_user.email
      end
    end
  end

  context 'User find all' do
    let!(:params) { { type: 'All', request: user_author.email } }
    let(:result) { subject.call }

    it 'returns array with user', sphinx: true do
      ThinkingSphinx::Test.run do
        expect(result.size).to eq 4
        result.each do |element|
          expect(%w[User Answer Question Comment]).to include(element.class.name)
        end
      end
    end
  end
end
